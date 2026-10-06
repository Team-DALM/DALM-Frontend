import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_progress_indicator.dart';
import 'package:flutter/material.dart';

class OnboardingPageLayout extends StatelessWidget {
  const OnboardingPageLayout({
    super.key,
    required this.visual,
    required this.title,
    required this.description,
    this.currentDay,
    this.showDayProgress = true,
    this.visualHeight = _defaultVisualHeight,
  }) : assert(
         !showDayProgress || currentDay != null,
         '진행 바를 표시하려면 currentDay가 필요합니다.',
       );

  final Widget visual;
  final int? currentDay;
  final bool showDayProgress;
  final double visualHeight;
  final String title;
  final String description;

  static const _defaultVisualHeight = 350.0;
  static const _referenceHeight = 650.0;
  static const _minimumScale = 0.75;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // 화면 높이에 맞는 비주얼 크기 계산
        final scale = (constraints.maxHeight / _referenceHeight).clamp(
          _minimumScale,
          1.0,
        );
        final responsiveVisualHeight = visualHeight * scale;

        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 84 * scale),
                SizedBox(
                  width: double.infinity,
                  height: responsiveVisualHeight,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: constraints.maxWidth,
                      height: visualHeight,
                      child: visual,
                    ),
                  ),
                ),
                const SizedBox(height: 21),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: _OnboardingPageText(
                    title: title,
                    description: description,
                    currentDay: currentDay,
                    showDayProgress: showDayProgress,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OnboardingPageText extends StatelessWidget {
  const _OnboardingPageText({
    required this.title,
    required this.description,
    required this.currentDay,
    required this.showDayProgress,
  });

  final String title;
  final String description;
  final int? currentDay;
  final bool showDayProgress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showDayProgress) ...[
          DalmProgressIndicator.daily(currentDay: currentDay!),
          const SizedBox(height: 24),
        ],
        Text(
          title,
          style: DalmTypography.serifHeadline.copyWith(
            fontSize: 23,
            color: DalmColors.textPrimary,
          ),
        ),
        const SizedBox(height: 13),
        Text(
          description,
          style: DalmTypography.body.copyWith(
            fontSize: 13,
            color: DalmColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
