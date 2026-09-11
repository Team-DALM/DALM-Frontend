import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/network/dio_provider.dart';
import 'package:dalm/core/storage/token_storage_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToNextScreen();
  }

  Future<void> _moveToNextScreen() async {
    final nextRouteFuture = _resolveNextRoute();

    // 스플래시 화면 최소 2초 유지
    await Future<void>.delayed(const Duration(seconds: 2));
    final nextRoute = await nextRouteFuture;

    if (!mounted) return;

    // 로그인 상태에 맞는 화면으로 이동
    context.go(nextRoute);
  }

  Future<String> _resolveNextRoute() async {
    try {
      final tokenStorage = ref.read(tokenStorageProvider);

      // 저장된 Refresh Token 확인
      final refreshToken = await tokenStorage.readRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        return AppRoutes.onboarding;
      }

      try {
        // Refresh Token으로 새 로그인 토큰 발급
        await ref.read(tokenRefresherProvider).refreshTokens();
        return AppRoutes.home;
      } on DioException catch (error) {
        final statusCode = error.response?.statusCode;

        if (statusCode == 401 || statusCode == 403) {
          // 만료된 로그인 토큰 삭제
          await tokenStorage.clearTokens();
          return AppRoutes.onboarding;
        }

        // 일시적인 네트워크 오류 시 로그인 상태 유지
        return AppRoutes.home;
      } on StateError {
        return AppRoutes.onboarding;
      }
    } on Object {
      return AppRoutes.onboarding;
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: _SplashContent());
  }
}

class _SplashContent extends StatelessWidget {
  const _SplashContent();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: DalmColors.background,
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 325),
            const _SplashBrandSection(),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.only(bottom: 48),
              child: _SplashFooter(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SplashBrandSection extends StatelessWidget {
  const _SplashBrandSection();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(width: 188, child: _ParallelLines()),
          const SizedBox(height: 24),
          Image.asset('assets/logos/logo_dalm.png', width: 169, height: 58),
          const SizedBox(height: 4),
          Text(
            '서로 다른 하루가 잠시 서로를 닮았어요.',
            textAlign: TextAlign.center,
            softWrap: false,
            style: DalmTypography.serifBody.copyWith(
              color: DalmColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashFooter extends StatelessWidget {
  const _SplashFooter();

  static const _postalWidth = 63.0;
  static const _postalHeight = 34.0;
  static const _spacing = 7.0;

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset((_postalWidth + _spacing) / 2, 0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            '사진 한 장에서 시작되는 우연',
            softWrap: false,
            style: DalmTypography.caption.copyWith(
              fontSize: 11,
              color: DalmColors.textSecondary,
            ),
          ),
          const SizedBox(width: _spacing),
          Image.asset(
            'assets/icons/splash_postal.png',
            width: _postalWidth,
            height: _postalHeight,
          ),
        ],
      ),
    );
  }
}

class _ParallelLines extends StatelessWidget {
  const _ParallelLines();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: ColoredBox(
            color: DalmColors.secondaryAction,
            child: SizedBox(height: 1),
          ),
        ),
        const SizedBox(width: 20),
        const Expanded(
          child: ColoredBox(
            color: DalmColors.secondaryAction,
            child: SizedBox(height: 1),
          ),
        ),
      ],
    );
  }
}
