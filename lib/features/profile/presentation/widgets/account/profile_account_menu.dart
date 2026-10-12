import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class ProfileAccountMenu extends StatelessWidget {
  const ProfileAccountMenu({
    super.key,
    required this.isLoggingOut,
    required this.onLogout,
    required this.onTermsTap,
    required this.onDeleteAccount,
  });

  final bool isLoggingOut;
  final VoidCallback onLogout;
  final VoidCallback onTermsTap;
  final VoidCallback onDeleteAccount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: DecoratedBox(
            decoration: const BoxDecoration(color: DalmColors.surfaceMuted),
            child: Column(
              children: [
                const _AccountMenuTile(
                  label: '앱 정보',
                  caption: '버전 1.0.0',
                ),
                const _MenuDivider(),
                _AccountMenuTile(label: '이용약관', onTap: onTermsTap),
                const _MenuDivider(),
                _AccountMenuTile(
                  label: isLoggingOut ? '로그아웃 중...' : '로그아웃',
                  onTap: isLoggingOut ? null : onLogout,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 18),
        ClipRRect(
          borderRadius: BorderRadius.circular(9),
          child: DecoratedBox(
            decoration: const BoxDecoration(color: DalmColors.surfaceMuted),
            child: _AccountMenuTile(
              label: '회원 탈퇴',
              caption: '모든 사진·매칭·엽서가 영구적으로 삭제돼요.',
              labelColor: DalmColors.destructive,
              onTap: onDeleteAccount,
            ),
          ),
        ),
      ],
    );
  }
}

class _AccountMenuTile extends StatelessWidget {
  const _AccountMenuTile({
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

class _MenuDivider extends StatelessWidget {
  const _MenuDivider();

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
