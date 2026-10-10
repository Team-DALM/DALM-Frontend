import 'dart:convert';
import 'dart:io';

import 'package:dalm/features/photo/data/providers/photo_analysis_providers.dart';
import 'package:dalm/features/photo/domain/entities/photo_analysis_progress.dart';
import 'package:dalm/features/photo/domain/repositories/photo_analysis_repository.dart';
import 'package:dalm/features/photo/presentation/views/photo_analysis_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDirectory;
  late File imageFile;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'dalm_analysis_test_',
    );
    imageFile = File('${tempDirectory.path}${Platform.pathSeparator}photo.png');
    await imageFile.writeAsBytes(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
      ),
    );
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  testWidgets('사진 분석 진행 화면을 표시한다', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_buildTestApp(imageFile.path));
    await tester.pumpAndSettle();

    expect(find.text('장면을 읽는 중'), findsOneWidget);
    expect(find.text('64%'), findsOneWidget);
    expect(find.text('사진 속 빛과 구도를 읽고 있어요.'), findsOneWidget);
    expect(find.text('잠시만 기다리면 오늘의 탐색이 시작돼요.'), findsOneWidget);
    expect(find.text('장면 이해'), findsOneWidget);
    expect(find.text('빛과 색'), findsOneWidget);
    expect(find.text('구도'), findsOneWidget);
    expect(find.text('안전 확인'), findsOneWidget);
    expect(find.text('앱을 닫아도 업로드는 계속 진행돼요.'), findsOneWidget);

    final imageSize = tester.getSize(
      find.byKey(const Key('photoAnalysisImage')),
    );
    expect(imageSize.width / imageSize.height, closeTo(4 / 5, 0.001));
    expect(tester.takeException(), isNull);
  });

  testWidgets('좁은 화면에서도 오버플로 없이 표시한다', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 700);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(_buildTestApp(imageFile.path));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('photoAnalysisProgressBadge')), findsOneWidget);
    expect(find.byKey(const Key('photoAnalysisSteps')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

Widget _buildTestApp(String imagePath) {
  return ProviderScope(
    overrides: [
      photoAnalysisRepositoryProvider.overrideWithValue(
        const _FixedAnalysisRepository(),
      ),
    ],
    child: MaterialApp(
      home: PhotoAnalysisScreen(
        imagePath: imagePath,
        photoId: 'test-photo-id',
        deleteImageOnDispose: false,
      ),
    ),
  );
}

final class _FixedAnalysisRepository implements PhotoAnalysisRepository {
  const _FixedAnalysisRepository();

  @override
  Stream<PhotoAnalysisProgress> watchProgress(String photoId) {
    return Stream.value(
      const PhotoAnalysisProgress(
        status: PhotoAnalysisStatus.validating,
        progress: 0.64,
        activeStep: 1,
      ),
    );
  }
}
