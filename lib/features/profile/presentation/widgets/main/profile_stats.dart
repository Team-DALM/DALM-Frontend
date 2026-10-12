import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  const ProfileStats({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: _StatItem(value: '23', label: '기록한 장면')),
        _StatDivider(),
        Expanded(child: _StatItem(value: '6', label: '발견한 순간')),
        _StatDivider(),
        Expanded(child: _StatItem(value: '4', label: '엽서')),
      ],
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: DalmTypography.serifHeadline.copyWith(
            color: DalmColors.textPrimary,
            fontSize: 19,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: DalmTypography.caption.copyWith(
            color: DalmColors.textSecondary,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}

class _StatDivider extends StatelessWidget {
  const _StatDivider();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: 36,
      child: VerticalDivider(
        width: 1,
        thickness: 1,
        color: DalmColors.border,
      ),
    );
  }
}
