import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../../../app/theme/dalm_colors.dart';
import '../../../../../app/theme/dalm_theme.dart';
import '../onboarding_page_indicator.dart';

Widget _previewFrame({required int currentPage}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: DalmTheme.light,
    home: Scaffold(
      backgroundColor: DalmColors.background,
      body: Center(child: OnboardingPageIndicator(currentPage: currentPage)),
    ),
  );
}

@Preview(
  name: '첫 번째 페이지',
  group: 'OnboardingPageIndicator',
  size: Size(390, 120),
)
Widget onboardingPageIndicatorFirstPreview() {
  return _previewFrame(currentPage: 0);
}

@Preview(
  name: '두 번째 페이지',
  group: 'OnboardingPageIndicator',
  size: Size(390, 120),
)
Widget onboardingPageIndicatorSecondPreview() {
  return _previewFrame(currentPage: 1);
}

@Preview(
  name: '세 번째 페이지',
  group: 'OnboardingPageIndicator',
  size: Size(390, 120),
)
Widget onboardingPageIndicatorThirdPreview() {
  return _previewFrame(currentPage: 2);
}
