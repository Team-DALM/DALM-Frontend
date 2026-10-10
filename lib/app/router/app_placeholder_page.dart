import 'package:flutter/material.dart';

import '../theme/dalm_colors.dart';
import '../theme/dalm_typography.dart';

class AppPlaceholderPage extends StatelessWidget {
  const AppPlaceholderPage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DalmColors.background,
      body: SafeArea(
        child: Center(
          child: Text(
            title,
            style: DalmTypography.serifHeadline.copyWith(
              color: DalmColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
