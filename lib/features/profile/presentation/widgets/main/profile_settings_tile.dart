import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class ProfileSettingsTile extends StatelessWidget {
  const ProfileSettingsTile({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final Widget icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: DalmColors.surfaceMuted,
      borderRadius: BorderRadius.circular(7),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(7),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
          child: Row(
            children: [
              SizedBox.square(
                dimension: 24,
                child: Center(child: icon),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: DalmTypography.bodyBold.copyWith(
                    color: DalmColors.textPrimary,
                    fontSize: 12,
                  ),
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
      ),
    );
  }
}
