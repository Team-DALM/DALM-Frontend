import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

/// 카메라 또는 앨범을 선택하는 액션 카드
class PhotoSourceActionCard extends StatelessWidget {
  const PhotoSourceActionCard({
    super.key,
    required this.icon,
    required this.iconBackgroundColor,
    required this.title,
    required this.description,
    required this.onPressed,
  });

  final IconData icon;
  final Color iconBackgroundColor;
  final String title;
  final String description;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      child: Material(
        color: DalmColors.surfaceMuted,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            height: 70,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: 36,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(icon, size: 22, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: DalmTypography.bodyBold.copyWith(
                            fontSize: 13,
                            height: 1.2,
                            color: DalmColors.textInk,
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          description,
                          style: DalmTypography.caption.copyWith(
                            fontSize: 9,
                            height: 1.2,
                            color: DalmColors.textWarm,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 18,
                    color: DalmColors.textWarm,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
