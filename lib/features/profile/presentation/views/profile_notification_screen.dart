import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_app_bar.dart';
import 'package:dalm/features/profile/presentation/widgets/notification/profile_notification_time_card.dart';
import 'package:dalm/features/profile/presentation/widgets/notification/profile_notification_toggle_card.dart';
import 'package:flutter/material.dart';

class ProfileNotificationScreen extends StatefulWidget {
  const ProfileNotificationScreen({super.key});

  @override
  State<ProfileNotificationScreen> createState() =>
      _ProfileNotificationScreenState();
}

class _ProfileNotificationScreenState extends State<ProfileNotificationScreen> {
  bool _dailyRecord = true;
  bool _matchedMoment = true;
  bool _newPostcard = true;
  bool _explorationComplete = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DalmColors.background,
      appBar: DalmAppBar(
        title: '알림 설정',
        showBackButton: true,
        dividerIndent: 20,
        titleStyle: DalmTypography.bodyBold.copyWith(
          color: DalmColors.textPrimary,
          fontSize: 14,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '필요한 순간에만 조용히 알려드릴게요.',
              style: DalmTypography.caption.copyWith(
                color: DalmColors.textWarm,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 28),
            ProfileNotificationToggleCard(
              title: '오늘 한 장 기록 알림',
              description: '매일 설정한 시간에 알려드려요.',
              value: _dailyRecord,
              onChanged: (value) => setState(() => _dailyRecord = value),
            ),
            const SizedBox(height: 10),
            ProfileNotificationToggleCard(
              title: '평행한 순간 발견',
              description: '새로운 매칭이 발견되면 알려드려요.',
              value: _matchedMoment,
              onChanged: (value) => setState(() => _matchedMoment = value),
            ),
            const SizedBox(height: 10),
            ProfileNotificationToggleCard(
              title: '새 엽서 도착',
              description: '익명 엽서가 도착하면 알려드려요.',
              value: _newPostcard,
              onChanged: (value) => setState(() => _newPostcard = value),
            ),
            const SizedBox(height: 10),
            ProfileNotificationToggleCard(
              title: '7일 탐색 종료',
              description: '매칭 여부와 기록 보관을 알려드려요.',
              value: _explorationComplete,
              onChanged: (value) => setState(
                () => _explorationComplete = value,
              ),
            ),
            const SizedBox(height: 36),
            const ProfileNotificationTimeCard(),
          ],
        ),
      ),
    );
  }
}
