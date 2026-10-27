import 'package:flutter/material.dart';

import '../../app/theme/dalm_colors.dart';
import '../../app/theme/dalm_typography.dart';

class DalmAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DalmAppBar({
    super.key,
    required this.title,
    this.showBackButton = false,
    this.onBackPressed,
    this.actionLabel,
    this.onActionPressed,
    this.infoLabel,
    this.onNotificationPressed,
    this.onMorePressed,
    this.titleStyle,
    this.leadingWidth,
    this.dividerIndent = 0,
    this.dividerColor = DalmColors.border,
  }) : assert(
         actionLabel == null || onActionPressed != null,
         'actionLabel을 사용하려면 onActionPressed도 전달해야 합니다.',
       ),
       assert(
         (actionLabel == null || infoLabel == null) &&
             (actionLabel == null || onNotificationPressed == null) &&
             (actionLabel == null || onMorePressed == null) &&
             (infoLabel == null || onMorePressed == null),
         '오른쪽 액션은 정보 문구, 알림, 더보기 버튼과 동시에 사용할 수 없습니다.',
       );

  final String title;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final String? infoLabel;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onMorePressed;
  final TextStyle? titleStyle;
  final double? leadingWidth;
  final double dividerIndent;
  final Color dividerColor;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: DalmColors.background,
      foregroundColor: DalmColors.textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,

      leading: showBackButton
          ? IconButton(
              onPressed:
                  onBackPressed ??
                  () {
                    Navigator.of(context).maybePop();
                  },
              icon: const Icon(Icons.chevron_left_rounded),
              tooltip: '뒤로 가기',
            )
          : null,
      leadingWidth: leadingWidth,

      titleSpacing: showBackButton ? 0 : 16,

      title: Text(
        title,
        style:
            titleStyle ??
            DalmTypography.title.copyWith(color: DalmColors.textPrimary),
      ),

      actions: [
        if (actionLabel != null)
          TextButton(
            onPressed: onActionPressed,
            style: TextButton.styleFrom(
              foregroundColor: DalmColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            child: Text(
              actionLabel!,
              style: DalmTypography.caption.copyWith(
                color: DalmColors.textSecondary,
              ),
            ),
          )
        else if (infoLabel != null)
          Padding(
            padding: EdgeInsets.only(
              left: 16,
              right: onNotificationPressed == null ? 16 : 4,
            ),
            child: Center(
              child: Text(
                infoLabel!,
                style: DalmTypography.caption.copyWith(
                  color: DalmColors.textSecondary,
                ),
              ),
            ),
          )
        else if (onMorePressed != null)
          IconButton(
            onPressed: onMorePressed,
            icon: const Icon(
              Icons.more_horiz_rounded,
              color: DalmColors.textSecondary,
            ),
            tooltip: '더보기',
          ),
        if (onNotificationPressed != null)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: IconButton(
              onPressed: onNotificationPressed,
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: DalmColors.textPrimary,
              ),
              tooltip: '알림',
            ),
          ),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(
          height: 1,
          thickness: 1,
          indent: dividerIndent,
          endIndent: dividerIndent,
          color: dividerColor,
        ),
      ),
    );
  }
}
