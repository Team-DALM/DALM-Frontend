import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_button.dart';
import 'package:dalm/features/onboarding/presentation/widgets/onboarding_first_page.dart';
import 'package:dalm/features/onboarding/presentation/widgets/onboarding_page_indicator.dart';
import 'package:dalm/features/onboarding/presentation/widgets/onboarding_second_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  static const _pageLabels = ['온보딩2', '온보딩3'];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _moveToNextPage() {
    if (_currentPage == _pageLabels.length) {
      context.go(AppRoutes.login);
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLastPage = _currentPage == _pageLabels.length;

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
                itemCount: _pageLabels.length + 1,
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

                  return Center(child: Text(_pageLabels[index - 1]));
                },
              ),
            ),
            OnboardingPageIndicator(currentPage: _currentPage),
            const SizedBox(height: 19),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 68),
              child: DalmButton(
                label: isLastPage ? '시작하기' : '다음',
                onPressed: _moveToNextPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
