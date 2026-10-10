import 'package:flutter/material.dart';

import 'theme/dalm_colors.dart';
import 'theme/dalm_theme.dart';
import 'theme/dalm_typography.dart';

class DalmApp extends StatelessWidget {
  const DalmApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DALM',
      debugShowCheckedModeBanner: false,
      theme: DalmTheme.light,
      home: const _FoundationScreen(),
    );
  }
}

class _FoundationScreen extends StatelessWidget {
  const _FoundationScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('DALM', style: DalmTypography.serifDisplay),
              SizedBox(height: 8),
              Text(
                '닮은 순간을 발견하는 중',
                style: TextStyle(color: DalmColors.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
