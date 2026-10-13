import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:flutter/material.dart';

class ProfileSkeletonBar extends StatelessWidget {
  const ProfileSkeletonBar({
    super.key,
    required this.width,
    required this.height,
    this.color = DalmColors.border,
  });

  final double width;
  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(height / 2),
      ),
    );
  }
}
