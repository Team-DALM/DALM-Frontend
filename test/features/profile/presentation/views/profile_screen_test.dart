import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/features/profile/presentation/routes/profile_routes.dart';
import 'package:dalm/features/profile/presentation/views/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('프로필 화면에 시선 분석과 이번 달 기록을 표시한다', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: ProfileScreen()));

    expect(find.text('나의 시선'), findsOneWidget);
    expect(find.text('평행한 여행자 02'), findsOneWidget);
    expect(find.textContaining('당신은 빛이 머무는'), findsOneWidget);
    expect(find.text('이번 달 기록'), findsOneWidget);
    expect(find.text('알림 설정'), findsOneWidget);
  });

  testWidgets('알림 설정을 누르면 알림 설정 화면으로 이동한다', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.profile,
      routes: [
        GoRoute(
          path: AppRoutes.profile,
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: ProfileRouteLocations.notificationSettings,
          builder: (context, state) =>
              const Scaffold(body: Text('NOTIFICATION')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await tester.ensureVisible(
      find.byKey(const Key('notification-settings-tile')),
    );
    await tester.tap(find.byKey(const Key('notification-settings-tile')));
    await tester.pumpAndSettle();

    expect(find.text('NOTIFICATION'), findsOneWidget);
  });
}
