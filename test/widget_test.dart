import 'package:dalm/app/app.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DALM 앱이 스플래시 화면으로 시작된다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: DalmApp()));

    expect(find.text('스플래시'), findsOneWidget);
  });
}
