import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/features/photo/presentation/routes/photo_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

void main() {
  testWidgets('사진 경로 없이 크롭 화면에 진입하면 사진 등록 화면으로 돌아간다', (tester) async {
    final router = GoRouter(
      initialLocation: AppRoutes.photoCrop,
      routes: photoRootRoutes,
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    expect(router.state.uri.path, AppRoutes.photoUpload);
    expect(find.text('오늘의 사진'), findsOneWidget);
  });
}
