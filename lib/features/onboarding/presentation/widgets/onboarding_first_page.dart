import 'package:dalm/core/widgets/dalm_photo_frame.dart';
import 'package:dalm/features/onboarding/presentation/widgets/onboarding_page_layout.dart';
import 'package:flutter/material.dart';

class OnboardingFirstPage extends StatelessWidget {
  const OnboardingFirstPage({super.key});

  static const _photoWidth = 274.0;
  static const _photoHeight = 350.0;
  static const _photoBadgeSize = 36.0;

  @override
  Widget build(BuildContext context) {
    return OnboardingPageLayout(
      currentDay: 2,
      title: '하루에서, 한 장만 남겨요.',
      description: '잘 찍은 사진보다 오늘 마음에 남은 장면을\n부담 없이 한 장 기록해보세요.',
      visual: Center(
        child: SizedBox(
          width: _photoWidth,
          height: _photoHeight,
          child: DalmPhotoFrame(
            image: const AssetImage('assets/images/onboarding_bus_1.png'),
            aspectRatio: _photoWidth / _photoHeight,
            borderRadius: const BorderRadius.all(Radius.circular(4)),
            overlay: Positioned(
              right: 28,
              bottom: 23,
              child: Image.asset(
                'assets/icons/onboarding_today_photo.png',
                width: _photoBadgeSize,
                height: _photoBadgeSize,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
