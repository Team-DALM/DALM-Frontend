import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:flutter/material.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.currentPage,
    this.totalPages = 3,
  }) : assert(totalPages > 1, 'totalPages는 2 이상이어야 합니다.'),
       assert(
         currentPage >= 0 && currentPage < totalPages,
         'currentPage는 0부터 totalPages보다 작아야 합니다.',
       );

  final int currentPage;
  final int totalPages;

  static const double _activeWidth = 20;
  static const double _inactiveWidth = 6;
  static const double _height = 6;
  static const double _gap = 6;
  static const Duration _animationDuration = Duration(milliseconds: 250);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(totalPages, (index) {
        final isActive = index == currentPage;

        return Padding(
          padding: EdgeInsets.only(right: index == totalPages - 1 ? 0 : _gap),
          child: AnimatedContainer(
            duration: _animationDuration,
            curve: Curves.easeOutCubic,
            width: isActive ? _activeWidth : _inactiveWidth,
            height: _height,
            decoration: BoxDecoration(
              color: isActive ? DalmColors.primaryAction : DalmColors.border,
              borderRadius: BorderRadius.circular(_height / 2),
            ),
          ),
        );
      }),
    );
  }
}
