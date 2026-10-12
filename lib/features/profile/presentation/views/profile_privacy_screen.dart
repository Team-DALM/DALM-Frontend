import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_app_bar.dart';
import 'package:dalm/features/profile/presentation/widgets/privacy/profile_privacy_menu.dart';
import 'package:dalm/features/profile/presentation/widgets/privacy/profile_privacy_toggle_card.dart';
import 'package:flutter/material.dart';

class ProfilePrivacyScreen extends StatefulWidget {
  const ProfilePrivacyScreen({super.key});

  @override
  State<ProfilePrivacyScreen> createState() => _ProfilePrivacyScreenState();
}

class _ProfilePrivacyScreenState extends State<ProfilePrivacyScreen> {
  bool _removePhotoMetadata = true;
  bool _joinAnonymousLearning = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DalmColors.background,
      appBar: DalmAppBar(
        title: '개인정보 및 안전',
        showBackButton: true,
        dividerIndent: 20,
        titleStyle: DalmTypography.bodyBold.copyWith(
          color: DalmColors.textPrimary,
          fontSize: 14,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 28, 22, 40),
        child: Column(
          children: [
            ProfilePrivacyToggleCard(
              title: '사진 촬영 정보 자동 제거',
              description: '날짜·기기·위치가 포함된 EXIF를 공유 전에 제거해요.',
              helperText: '상대에게는 사진과 익명 번호만 보여요.',
              value: _removePhotoMetadata,
              onChanged: (value) {
                setState(() => _removePhotoMetadata = value);
              },
            ),
            const SizedBox(height: 20),
            ProfilePrivacyToggleCard(
              title: '서비스 개선을 위한 익명 학습 참여',
              description: '동의한 사진만 모델 개선에 사용돼요.',
              helperText: '기본값은 참여하지 않음이에요.',
              helperColor: DalmColors.destructive,
              value: _joinAnonymousLearning,
              onChanged: (value) {
                setState(() => _joinAnonymousLearning = value);
              },
            ),
            const SizedBox(height: 22),
            ProfilePrivacyMenu(
              onHiddenPostcardsTap: () {},
              onBlockedUsersTap: () {},
              onReportsTap: () {},
            ),
            const SizedBox(height: 22),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Text(
                    '개인정보 처리방침',
                    style: DalmTypography.caption.copyWith(
                      color: DalmColors.textWarm,
                      fontSize: 9,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      foregroundColor: DalmColors.secondaryAction,
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(64, 32),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      '자세히 보기 →',
                      style: DalmTypography.caption.copyWith(fontSize: 9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
