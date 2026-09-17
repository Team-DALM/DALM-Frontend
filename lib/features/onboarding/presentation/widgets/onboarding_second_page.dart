import 'package:dalm/core/widgets/dalm_overlapping_photos.dart';
import 'package:dalm/features/onboarding/presentation/widgets/onboarding_page_layout.dart';
import 'package:flutter/material.dart';

class OnboardingSecondPage extends StatelessWidget {
  const OnboardingSecondPage({super.key});

  static const _photoWidth = 218.0;
  static const _photoHeight = 290.0;

  @override
  Widget build(BuildContext context) {
    return const OnboardingPageLayout(
      currentDay: 5,
      title: '7일 동안, 닮은 시선을 찾아요.',
      description: '가까운 곳에서 기록된 장면 중\n구도와 빛, 분위기가 닮은 한 장을 연결해요.',
      visual: Padding(
        padding: EdgeInsets.only(left: 52),
        child: Align(
          alignment: Alignment.topLeft,
          child: DalmOverlappingPhotos(
            firstImage: AssetImage('assets/images/onboarding_bus_1.png'),
            secondImage: AssetImage('assets/images/onboarding_bus_2.png'),
            photoWidth: OnboardingSecondPage._photoWidth,
            photoHeight: OnboardingSecondPage._photoHeight,
            horizontalOffset: 85,
            verticalOffset: 43,
            firstLabel: 'DAY 01',
            secondLabel: 'WITHIN 07 DAYS',
          ),
        ),
      ),
    );
  }
}
