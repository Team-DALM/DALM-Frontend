import 'package:flutter/material.dart';

import '../../app/theme/dalm_colors.dart';
import '../../app/theme/dalm_typography.dart';

enum _DalmProgressVariant { linear, daily }

class DalmProgressIndicator extends StatelessWidget {
  const DalmProgressIndicator.linear({
    super.key,
    required this.currentDay,
    this.totalDays = 7,
  }) : _variant = _DalmProgressVariant.linear,
       showDayLabels = false,
       assert(totalDays > 1, 'totalDays는 2 이상이어야 합니다.'),
       assert(
         currentDay >= 1 && currentDay <= totalDays,
         'currentDay는 1부터 totalDays 사이여야 합니다.',
       );

  const DalmProgressIndicator.daily({
    super.key,
    required this.currentDay,
    this.totalDays = 7,
    this.showDayLabels = true,
  }) : _variant = _DalmProgressVariant.daily,
       assert(totalDays > 1, 'totalDays는 2 이상이어야 합니다.'),
       assert(
         currentDay >= 1 && currentDay <= totalDays,
         'currentDay는 1부터 totalDays 사이여야 합니다.',
       );

  final _DalmProgressVariant _variant;

  final int currentDay;
  final int totalDays;
  final bool showDayLabels;

  static const double _trackHeight = 2;
  static const double _smallDotSize = 8;
  static const double _currentDotSize = 14;
  static const double _labelGap = 12;

  static const LinearGradient _activeGradient = LinearGradient(
    colors: [
      DalmColors.secondaryAction,
      DalmColors.emotionalAccent,
      DalmColors.destructive,
    ],
  );

  double get _progress {
    return (currentDay - 1) / (totalDays - 1);
  }

  @override
  Widget build(BuildContext context) {
    return switch (_variant) {
      _DalmProgressVariant.linear => _buildLinear(),
      _DalmProgressVariant.daily => _buildDaily(),
    };
  }

  Widget _buildLinear() {
    return _buildTrack(showDailyDots: false);
  }

  Widget _buildDaily() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTrack(showDailyDots: true),

        if (showDayLabels) ...[
          const SizedBox(height: _labelGap),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'DAY 1',
                style: DalmTypography.caption.copyWith(
                  color: DalmColors.textSecondary,
                ),
              ),
              Text(
                'DAY $totalDays',
                style: DalmTypography.caption.copyWith(
                  color: DalmColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildTrack({required bool showDailyDots}) {
    return SizedBox(
      height: _currentDotSize,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final availableWidth = constraints.maxWidth - _currentDotSize;

          final currentPosition = availableWidth * _progress;

          return Stack(
            children: [
              // 전체 배경 선
              Positioned(
                left: _currentDotSize / 2,
                right: _currentDotSize / 2,
                top: (_currentDotSize - _trackHeight) / 2,
                child: Container(
                  height: _trackHeight,
                  color: DalmColors.border,
                ),
              ),

              // 현재 날짜까지 진행된 Gradient 선
              Positioned(
                left: _currentDotSize / 2,
                width: currentPosition,
                top: (_currentDotSize - _trackHeight) / 2,
                child: Container(
                  height: _trackHeight,
                  decoration: const BoxDecoration(gradient: _activeGradient),
                ),
              ),

              if (showDailyDots)
                for (int index = 0; index < totalDays; index++)
                  _buildDailyDot(index: index, availableWidth: availableWidth)
              else
                _buildCurrentDot(position: currentPosition),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCurrentDot({required double position}) {
    return Positioned(
      left: position,
      top: 0,
      child: Container(
        width: _currentDotSize,
        height: _currentDotSize,
        decoration: const BoxDecoration(
          color: DalmColors.emotionalAccent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildDailyDot({required int index, required double availableWidth}) {
    final day = index + 1;
    final isCurrent = day == currentDay;
    final isCompleted = day < currentDay;

    final dotSize = isCurrent ? _currentDotSize : _smallDotSize;

    final position = availableWidth * index / (totalDays - 1);

    final left = position + (_currentDotSize - dotSize) / 2;

    final color = isCurrent
        ? DalmColors.emotionalAccent
        : isCompleted
        ? DalmColors.secondaryAction
        : DalmColors.border;

    return Positioned(
      left: left,
      top: (_currentDotSize - dotSize) / 2,
      child: Container(
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
    );
  }
}
