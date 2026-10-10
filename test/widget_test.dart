import 'package:dalm/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DALM 앱이 정상적으로 시작된다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: DalmApp()));

    expect(find.text('DALM'), findsOneWidget);
    expect(find.text('닮은 순간을 발견하는 중'), findsOneWidget);
  });
}
