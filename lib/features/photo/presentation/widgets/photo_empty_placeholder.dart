import 'dart:math' as math;

import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class PhotoEmptyPlaceholder extends StatelessWidget {
  const PhotoEmptyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: const _DashedRoundedBorderPainter(),
      child: const SizedBox(
        width: 240,
        height: 300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _AddPhotoIcon(),
            SizedBox(height: 17),
            Text(
              '사진 한 장',
              style: TextStyle(
                fontFamily: DalmTypography.inter,
                fontSize: 13,
                height: 1.2,
                fontWeight: FontWeight.w700,
                color: DalmColors.textPrimary,
              ),
            ),
            SizedBox(height: 17),
            Text(
              '4:5 세로 비율로 기록돼요.',
              style: TextStyle(
                fontFamily: DalmTypography.inter,
                fontSize: 10,
                height: 1.2,
                color: DalmColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddPhotoIcon extends StatelessWidget {
  const _AddPhotoIcon();

  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 72,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: DalmColors.background,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.add,
          size: 39,
          weight: 200,
          color: DalmColors.secondaryAction,
        ),
      ),
    );
  }
}

class _DashedRoundedBorderPainter extends CustomPainter {
  const _DashedRoundedBorderPainter();

  static const _radius = Radius.circular(8);
  static const _dashLength = 5.0;
  static const _gapLength = 5.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = DalmColors.border
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(Offset.zero & size, _radius).deflate(0.5),
      );

    for (final metric in path.computeMetrics()) {
      for (
        double distance = 0;
        distance < metric.length;
        distance += _dashLength + _gapLength
      ) {
        canvas.drawPath(
          metric.extractPath(
            distance,
            math.min(distance + _dashLength, metric.length),
          ),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
