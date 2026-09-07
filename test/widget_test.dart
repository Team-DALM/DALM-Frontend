import 'package:dalm/app/app.dart';
import 'package:dalm/core/widgets/dalm_bottom_navigation_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DALM 앱이 스플래시 화면으로 시작된다', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: DalmApp()));

    expect(find.text('서로 다른 하루가 잠시 서로를 닮았어요.'), findsOneWidget);
  });

  testWidgets('바텀 네비게이션 메뉴를 표시한다', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          bottomNavigationBar: DalmBottomNavigationBar(
            currentIndex: 0,
            onTap: _onNavigationTap,
          ),
        ),
      ),
    );

    expect(find.text('오늘'), findsOneWidget);
    expect(find.text('순간들'), findsOneWidget);
    expect(find.text('엽서함'), findsOneWidget);
    expect(find.text('나'), findsOneWidget);
  });
}

void _onNavigationTap(int index) {}
