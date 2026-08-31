import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/core/widgets/dalm_button.dart';
import 'package:dalm/features/onboarding/widgets/onboarding_page_indicator.dart';
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

  static const _pageLabels = ['온보딩1', '온보딩2', '온보딩3'];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _moveToNextPage() {
    if (_currentPage == _pageLabels.length - 1) {
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
    final isLastPage = _currentPage == _pageLabels.length - 1;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pageLabels.length,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                },
                itemBuilder: (context, index) {
                  return Center(child: Text(_pageLabels[index]));
                },
              ),
            ),
            OnboardingPageIndicator(currentPage: _currentPage),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
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
