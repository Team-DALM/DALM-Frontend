import 'package:dalm/features/photo/data/repositories/fake_photo_analysis_repository.dart';
import 'package:dalm/features/photo/domain/entities/photo_analysis_progress.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('개발용 분석 상태가 단계별로 진행된 뒤 SEARCHING이 된다', () async {
    const repository = FakePhotoAnalysisRepository(stepDuration: Duration.zero);

    final states = await repository.watchProgress('photo-id').toList();

    expect(states.map((state) => state.progress), [0.16, 0.38, 0.64, 0.86, 1]);
    expect(states.last.status, PhotoAnalysisStatus.searching);
    expect(states.last.activeStep, 3);
  });

  test('개발용 분석 결과를 REJECTED로 지정할 수 있다', () async {
    const repository = FakePhotoAnalysisRepository(
      result: PhotoAnalysisStatus.rejected,
      stepDuration: Duration.zero,
    );

    final states = await repository.watchProgress('photo-id').toList();

    expect(states.last.status, PhotoAnalysisStatus.rejected);
    expect(states.last.isComplete, isTrue);
  });
}
