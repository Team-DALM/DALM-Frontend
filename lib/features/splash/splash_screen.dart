import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToOnboarding();
  }

  Future<void> _moveToOnboarding() async {
    await Future<void>.delayed(const Duration(seconds: 2)); // 2초 뒤

    if (!mounted) return;

    context.go(AppRoutes.onboarding); // 온보딩으로 넘어감
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _SplashContent(),
    );
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
          Image.asset(
            'assets/logos/logo_dalm.png',
            width: 169,
            height: 58,
          ),
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
