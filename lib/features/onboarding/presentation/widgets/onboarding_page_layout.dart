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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 84),
        SizedBox(width: double.infinity, height: visualHeight, child: visual),
        const SizedBox(height: 21),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
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
          ),
        ),
      ],
    );
  }
}
