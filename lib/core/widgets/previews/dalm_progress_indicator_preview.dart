import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../app/theme/dalm_colors.dart';
import '../../../app/theme/dalm_theme.dart';
import '../dalm_progress_indicator.dart';

Widget _previewFrame({required Widget child}) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: DalmTheme.light,
    home: Scaffold(
      backgroundColor: DalmColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SizedBox(width: 342, child: child),
        ),
      ),
    ),
  );
}

@Preview(
  name: 'Linear · Day 4',
  group: 'DalmProgressIndicator',
  size: Size(390, 100),
)
Widget dalmLinearProgressPreview() {
  return _previewFrame(
    child: const DalmProgressIndicator.linear(currentDay: 7, totalDays: 7),
  );
}

@Preview(
  name: 'Daily · Day 4',
  group: 'DalmProgressIndicator',
  size: Size(390, 130),
)
Widget dalmDailyProgressPreview() {
  return _previewFrame(
    child: const DalmProgressIndicator.daily(currentDay: 7, totalDays: 7),
  );
}
