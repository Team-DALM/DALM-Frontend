import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class ProfileMenuTile extends StatelessWidget {
  const ProfileMenuTile({
    super.key,
    required this.label,
    this.caption,
    this.labelColor = DalmColors.textPrimary,
    this.onTap,
  });

  final String label;
  final String? caption;
  final Color labelColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: DalmTypography.bodyBold.copyWith(
                      color: labelColor,
                      fontSize: 13,
                    ),
                  ),
                  if (caption != null) ...[
                    const SizedBox(height: 7),
                    Text(
                      caption!,
                      style: DalmTypography.caption.copyWith(
                        color: DalmColors.textSecondary,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right,
              color: DalmColors.textWarm,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileMenuDivider extends StatelessWidget {
  const ProfileMenuDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 20,
      endIndent: 20,
      color: DalmColors.border,
    );
  }
}
