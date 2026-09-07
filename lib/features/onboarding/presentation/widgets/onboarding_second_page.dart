import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/widgets/dalm_photo_frame.dart';
import 'package:dalm/features/onboarding/presentation/widgets/onboarding_page_layout.dart';
import 'package:flutter/material.dart';

class OnboardingSecondPage extends StatelessWidget {
  const OnboardingSecondPage({super.key});

  static const _photoWidth = 184.0;
  static const _photoHeight = 246.0;

  @override
  Widget build(BuildContext context) {
    return const OnboardingPageLayout(
      currentDay: 4,
      title: '7일 동안, 닮은 시선을 찾아요.',
      description: '가까운 곳에서 기록된 장면 중\n구도와 빛, 분위기가 닮은 한 장을 연결해요.',
      visual: Padding(
        padding: EdgeInsets.only(left: 43),
        child: SizedBox(width: 264, height: 284, child: _OverlappingPhotos()),
      ),
    );
  }
}

class _OverlappingPhotos extends StatelessWidget {
  const _OverlappingPhotos();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          width: OnboardingSecondPage._photoWidth,
          height: OnboardingSecondPage._photoHeight,
          child: _PhotoCard(
            imagePath: 'assets/images/onboarding_bus_1.png',
            label: 'DAY 01',
          ),
        ),
        Positioned(
          top: 39,
          left: 80,
          width: OnboardingSecondPage._photoWidth,
          height: OnboardingSecondPage._photoHeight,
          child: _PhotoCard(
            imagePath: 'assets/images/onboarding_bus_2.png',
            label: 'WITHIN 07 DAYS',
          ),
        ),
      ],
    );
  }
}

class _PhotoCard extends StatelessWidget {
  const _PhotoCard({required this.imagePath, required this.label});

  final String imagePath;
  final String label;

  @override
  Widget build(BuildContext context) {
    return DalmPhotoFrame(
      image: AssetImage(imagePath),
      aspectRatio:
          OnboardingSecondPage._photoWidth /
          OnboardingSecondPage._photoHeight,
      borderRadius: const BorderRadius.all(Radius.circular(4)),
      overlay: Positioned(
        left: 10,
        bottom: 10,
        child: Text(
          label,
          style: DalmTypography.caption.copyWith(
            fontSize: 8,
            fontWeight: FontWeight.w500,
            color: DalmColors.textInverse,
          ),
        ),
      ),
    );
  }
}
