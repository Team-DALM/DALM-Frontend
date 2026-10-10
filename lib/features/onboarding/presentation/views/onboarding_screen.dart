import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/storage/token_storage_provider.dart';
import 'package:dalm/core/widgets/dalm_button.dart';
import 'package:dalm/features/onboarding/presentation/widgets/onboarding_first_page.dart';
import 'package:dalm/features/onboarding/presentation/widgets/onboarding_page_indicator.dart';
import 'package:dalm/features/onboarding/presentation/widgets/onboarding_second_page.dart';
import 'package:dalm/features/onboarding/presentation/widgets/onboarding_third_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  bool _isCheckingLogin = false;

  static const _pageCount = 3;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _moveToNextPage() async {
    if (_currentPage == _pageCount - 1) {
      await _moveAfterLoginCheck();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  Future<void> _moveAfterLoginCheck() async {
    if (_isCheckingLogin) return;
    setState(() => _isCheckingLogin = true);

    try {
      // 저장된 Refresh Token으로 로그인 여부 확인
      final refreshToken = await ref
          .read(tokenStorageProvider)
          .readRefreshToken();

      if (!mounted) return;

      final nextRoute = refreshToken == null || refreshToken.isEmpty
          ? AppRoutes.login
          : AppRoutes.home;
      context.go(nextRoute);
    } on Object {
      if (mounted) context.go(AppRoutes.login);
    } finally {
      if (mounted) setState(() => _isCheckingLogin = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pageCount - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 24),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'DALM',
                  style: DalmTypography.caption.copyWith(
                    fontWeight: FontWeight.w700,
                    color: DalmColors.textPrimary,
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pageCount,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return const OnboardingFirstPage();
                  }

                  if (index == 1) {
                    return const OnboardingSecondPage();
                  }

                  return const OnboardingThirdPage();
                },
              ),
            ),
            OnboardingPageIndicator(currentPage: _currentPage),
            const SizedBox(height: 19),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 68),
              child: DalmButton(
                label: isLastPage ? 'DALM 시작하기' : '다음',
                isLoading: _isCheckingLogin,
                onPressed: () => _moveToNextPage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
