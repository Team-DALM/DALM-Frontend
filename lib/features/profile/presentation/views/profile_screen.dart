import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_app_bar.dart';
import 'package:dalm/features/profile/presentation/routes/profile_routes.dart';
import 'package:dalm/features/profile/presentation/view_models/profile_view_model.dart';
import 'package:dalm/features/profile/presentation/widgets/main/profile_recent_records.dart';
import 'package:dalm/features/profile/presentation/widgets/main/profile_settings_tile.dart';
import 'package:dalm/features/profile/presentation/widgets/main/profile_stats.dart';
import 'package:dalm/features/profile/presentation/widgets/main/profile_traveler_card.dart';
import 'package:dalm/features/profile/presentation/widgets/main/profile_vision_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModelProvider);

    return Scaffold(
      backgroundColor: DalmColors.background,
      appBar: DalmAppBar(
        title: 'PARALLEL',
        actionLabel: '설정',
        onActionPressed: () {},
        dividerIndent: 20,
        titleStyle: DalmTypography.caption.copyWith(
          color: DalmColors.textPrimary,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.2,
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(profileViewModelProvider.notifier).refresh(),
        child: SingleChildScrollView(
          key: const Key('profile-scroll-view'),
          physics: const AlwaysScrollableScrollPhysics(),
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
            profileState.when(
              data: (profile) => ProfileTravelerCard(
                nickname: profile.nickname,
                recordSince: _formatRecordSince(profile.createdAt),
                onTap: () =>
                    context.push(ProfileRouteLocations.accountSettings),
              ),
              loading: () => ProfileTravelerCard(
                nickname: '',
                recordSince: '',
                isLoading: true,
              ),
              error: (error, stackTrace) => ProfileTravelerCard(
                nickname: '프로필을 불러오지 못했어요.',
                recordSince: '화면을 새로고침하여 다시 시도해 주세요.',
              ),
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
                size: 26,
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
      ),
    );
  }

  String _formatRecordSince(DateTime createdAt) {
    final localDate = createdAt.toLocal();
    return '${localDate.year}년 ${localDate.month}월부터 기록 중';
  }
}
