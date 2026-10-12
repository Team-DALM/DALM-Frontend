import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/features/profile/presentation/widgets/shared/profile_menu_tile.dart';
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
                const ProfileMenuTile(
                  label: '앱 정보',
                  caption: '버전 1.0.0',
                ),
                const ProfileMenuDivider(),
                ProfileMenuTile(label: '이용약관', onTap: onTermsTap),
                const ProfileMenuDivider(),
                ProfileMenuTile(
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
            child: ProfileMenuTile(
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
