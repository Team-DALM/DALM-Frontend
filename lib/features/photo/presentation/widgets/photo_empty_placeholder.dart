import 'dart:math' as math;

import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class PhotoEmptyPlaceholder extends StatelessWidget {
  const PhotoEmptyPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      height: 300,
      child: CustomPaint(
        foregroundPainter: const _DashedRoundedBorderPainter(),
        child: Material(
          color: DalmColors.surfaceMuted,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: Clip.antiAlias,
          child: const Stack(
            children: [
              Positioned(top: 91, left: 0, right: 0, child: _AddPhotoIcon()),
              Positioned(
                top: 168,
                left: 0,
                right: 0,
                child: Text(
                  '사진 한 장',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: DalmTypography.inter,
                    fontSize: 13,
                    height: 1.2,
                    fontWeight: FontWeight.w700,
                    color: DalmColors.textInk,
                  ),
                ),
              ),
              Positioned(
                top: 200,
                left: 0,
                right: 0,
                child: Text(
                  '4:5 세로 비율로 기록돼요.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: DalmTypography.inter,
                    fontSize: 10,
                    height: 1.2,
                    color: DalmColors.textWarm,
                  ),
                ),
              ),
            ],
          ),
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
      dimension: 62,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: DalmColors.background,
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.add,
          size: 30,
          weight: 200,
          color: DalmColors.secondaryAction,
        ),
      ),
    );
  }
}

class _DashedRoundedBorderPainter extends CustomPainter {
  const _DashedRoundedBorderPainter();

  static const _radius = Radius.circular(12);
  static const _dashLength = 6.0;
  static const _gapLength = 7.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = DalmColors.warmBorder
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
