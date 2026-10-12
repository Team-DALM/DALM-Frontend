import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_app_bar.dart';
import 'package:dalm/features/profile/presentation/widgets/vision_detail/profile_composition_card.dart';
import 'package:dalm/features/profile/presentation/widgets/vision_detail/profile_scene_card.dart';
import 'package:dalm/features/profile/presentation/widgets/vision_detail/profile_time_card.dart';
import 'package:flutter/material.dart';

class ProfileVisionDetailScreen extends StatelessWidget {
  const ProfileVisionDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DalmColors.background,
      appBar: DalmAppBar(
        title: '8월의 시선',
        showBackButton: true,
        actionLabel: 'AI 분석',
        onActionPressed: () {},
        dividerIndent: 20,
        titleStyle: DalmTypography.bodyBold.copyWith(
          color: DalmColors.textPrimary,
          fontSize: 14,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 18, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'AUGUST 2026 · 23 MOMENTS',
              style: DalmTypography.caption.copyWith(
                color: DalmColors.secondaryAction,
                fontSize: 9,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              '빛이 머무는 조용한 공간을\n자주 바라본 한 달이었어요.',
              style: DalmTypography.serifHeadline.copyWith(
                color: DalmColors.textPrimary,
                fontSize: 22,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 22),
            const ProfileSceneCard(),
            const SizedBox(height: 20),
            const ProfileTimeCard(),
            const SizedBox(height: 20),
            const ProfileCompositionCard(),
          ],
        ),
      ),
    );
  }
}
