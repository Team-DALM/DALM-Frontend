import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class PhotoAnalysisSteps extends StatelessWidget {
  const PhotoAnalysisSteps({super.key, required this.activeStep});

  final int activeStep;

  static const _labels = ['장면 이해', '빛과 색', '구도', '안전 확인'];

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('photoAnalysisSteps'),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            children: List.generate(_labels.length * 2 - 1, (index) {
              if (index.isOdd) {
                final lineIndex = index ~/ 2;
                return Expanded(
                  child: Container(
                    height: 1,
                    color: lineIndex < activeStep
                        ? DalmColors.emotionalAccent
                        : DalmColors.border,
                  ),
                );
              }

              final step = index ~/ 2;
              final color = step < activeStep
                  ? DalmColors.secondaryAction
                  : step == activeStep
                  ? DalmColors.emotionalAccent
                  : DalmColors.border;

              return Container(
                width: step == 1 ? 10 : 8,
                height: step == 1 ? 10 : 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              );
            }),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: _labels
              .map(
                (label) => SizedBox(
                  width: 58,
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: DalmTypography.caption.copyWith(
                      fontSize: 9,
                      color: DalmColors.textSecondary,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}
