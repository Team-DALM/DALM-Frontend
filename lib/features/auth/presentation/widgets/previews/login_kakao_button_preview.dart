import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_theme.dart';
import 'package:dalm/features/auth/presentation/widgets/login_kakao_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

void _onPreviewPressed() {}

@Preview(name: '기본', group: 'LoginKakaoButton', size: Size(390, 140))
Widget kakaoLoginButtonPreview() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: DalmTheme.light,
    home: Scaffold(
      backgroundColor: DalmColors.background,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Center(child: LoginKakaoButton(onPressed: _onPreviewPressed)),
      ),
    ),
  );
}
