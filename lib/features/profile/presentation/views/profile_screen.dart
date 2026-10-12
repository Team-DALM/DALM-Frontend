import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_app_bar.dart';
import 'package:dalm/features/profile/presentation/routes/profile_routes.dart';
import 'package:dalm/features/profile/presentation/widgets/main/profile_recent_records.dart';
import 'package:dalm/features/profile/presentation/widgets/main/profile_settings_tile.dart';
import 'package:dalm/features/profile/presentation/widgets/main/profile_stats.dart';
import 'package:dalm/features/profile/presentation/widgets/main/profile_traveler_card.dart';
import 'package:dalm/features/profile/presentation/widgets/main/profile_vision_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DalmColors.background,
      appBar: DalmAppBar(
        title: 'PARALLEL',
        actionLabel: '설정',
        onActionPressed: () =>
            context.push(ProfileRouteLocations.accountSettings),
        dividerIndent: 20,
        titleStyle: DalmTypography.caption.copyWith(
          color: DalmColors.textPrimary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
      ),
      body: SingleChildScrollView(
        key: const Key('profile-scroll-view'),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '나의 시선',
              style: DalmTypography.serifHeadline.copyWith(
                color: DalmColors.textPrimary,
                fontSize: 26,
              ),
            ),
            const SizedBox(height: 13),
            ProfileTravelerCard(
              onTap: () => context.push(ProfileRouteLocations.insight),
            ),
            const SizedBox(height: 19),
            ProfileVisionCard(
              onTap: () => context.push(ProfileRouteLocations.insight),
            ),
            const SizedBox(height: 24),
            const ProfileStats(),
            const SizedBox(height: 22),
            const ProfileRecentRecords(),
            const SizedBox(height: 28),
            ProfileSettingsTile(
              key: const Key('notification-settings-tile'),
              label: '알림 설정',
              icon: const Icon(
                Icons.notifications_none_rounded,
                color: DalmColors.textPrimary,
                size: 24,
              ),
              onTap: () =>
                  context.push(ProfileRouteLocations.notificationSettings),
            ),
            const SizedBox(height: 8),
            ProfileSettingsTile(
              key: const Key('privacy-settings-tile'),
              label: '개인정보 설정',
              icon: Image.asset(
                'assets/icons/profile_privacy_settings.png',
                width: 24,
                height: 24,
              ),
              onTap: () =>
                  context.push(ProfileRouteLocations.privacySettings),
            ),
            const SizedBox(height: 8),
            ProfileSettingsTile(
              key: const Key('account-settings-tile'),
              label: '계정 설정',
              icon: const Icon(
                Icons.account_circle_outlined,
                color: DalmColors.textPrimary,
                size: 24,
              ),
              onTap: () =>
                  context.push(ProfileRouteLocations.accountSettings),
            ),
          ],
        ),
      ),
    );
  }
}
