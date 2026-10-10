import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_photo_pair.dart';
import 'package:dalm/features/onboarding/presentation/widgets/onboarding_page_layout.dart';
import 'package:flutter/material.dart';

class OnboardingThirdPage extends StatelessWidget {
  const OnboardingThirdPage({super.key});

  static const _postcardWidth = 326.0;
  static const _postcardHeight = 411.0;
  static const _photoPairWidth = 286.0;
  static const _photoPairImageAspectRatio = 139 / 181;

  @override
  Widget build(BuildContext context) {
    return const OnboardingPageLayout(
      showDayProgress: false,
      visualHeight: _postcardHeight,
      title: '닮은 순간에, 엽서 한 장.',
      description: '실시간 채팅 대신 단 한 번의 마음을\n익명의 엽서로 조용히 건넬 수 있어요.',
      visual: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: _Postcard(),
      ),
    );
  }
}

class _Postcard extends StatelessWidget {
  const _Postcard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: OnboardingThirdPage._postcardWidth,
      height: OnboardingThirdPage._postcardHeight,
      padding: const EdgeInsets.fromLTRB(16, 37, 16, 0),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAF6),
        border: Border.all(color: DalmColors.border),
        borderRadius: const BorderRadius.all(Radius.circular(6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: SizedBox(
              width: OnboardingThirdPage._photoPairWidth,
              child: DalmPhotoPair(
                leftImage: AssetImage('assets/images/onboarding_bus_1.png'),
                rightImage: AssetImage('assets/images/onboarding_bus_2.png'),
                status: DalmPhotoPairStatus.revealed,
                imageAspectRatio:
                    OnboardingThirdPage._photoPairImageAspectRatio,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Center(child: _PostcardMessage()),
        ],
      ),
    );
  }
}

class _PostcardMessage extends StatelessWidget {
  const _PostcardMessage();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 286,
      height: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 286, height: 1, color: const Color(0xFFD8D2C8)),
          const SizedBox(height: 24),
          Text(
            '오늘 당신의 장면 너머에\n제 하루도 조금 다르게 보였어요.',
            style: DalmTypography.serifBody.copyWith(
              fontSize: 15,
              color: DalmColors.textPrimary,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 27,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                const Positioned(
                  top: 0,
                  left: 0,
                  child: _PostcardLine(width: 196),
                ),
                const Positioned(
                  top: 21,
                  left: 0,
                  child: _PostcardLine(width: 174),
                ),
                Positioned(
                  top: -10,
                  right: -4,
                  child: Image.asset(
                    'assets/icons/splash_postal.png',
                    width: 61,
                    height: 37,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PostcardLine extends StatelessWidget {
  const _PostcardLine({this.width = double.infinity});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(width: width, height: 1, color: const Color(0xFFD8D2C8));
  }
}
