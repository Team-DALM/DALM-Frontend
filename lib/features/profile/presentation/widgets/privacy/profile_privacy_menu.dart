import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/features/profile/presentation/widgets/shared/profile_menu_tile.dart';
import 'package:flutter/material.dart';

class ProfilePrivacyMenu extends StatelessWidget {
  const ProfilePrivacyMenu({
    super.key,
    required this.onHiddenPostcardsTap,
    required this.onBlockedUsersTap,
    required this.onReportsTap,
  });

  final VoidCallback onHiddenPostcardsTap;
  final VoidCallback onBlockedUsersTap;
  final VoidCallback onReportsTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(9),
      child: ColoredBox(
        color: DalmColors.surfaceMuted,
        child: Column(
          children: [
            ProfileMenuTile(
              label: '숨긴 엽서',
              caption: '다시 표시하거나 완전히 삭제할 수 있어요.',
              onTap: onHiddenPostcardsTap,
            ),
            const ProfileMenuDivider(),
            ProfileMenuTile(
              label: '차단된 익명 사용자',
              caption: '차단 목록을 확인하고 해제할 수 있어요.',
              onTap: onBlockedUsersTap,
            ),
            const ProfileMenuDivider(),
            ProfileMenuTile(
              label: '신고 내역',
              caption: '처리 상태와 결과를 확인할 수 있어요.',
              onTap: onReportsTap,
            ),
          ],
        ),
      ),
    );
  }
}
