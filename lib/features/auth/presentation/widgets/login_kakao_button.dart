import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class LoginKakaoButton extends StatelessWidget {
  const LoginKakaoButton({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: DalmColors.kakao,
          foregroundColor: DalmColors.kakaoText,
          elevation: 0,
          textStyle: DalmTypography.button,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/icons/login_kakao.png', width: 26, height: 24),
            const SizedBox(width: 22.5),
            const Text('카카오로 계속하기'),
          ],
        ),
      ),
    );
  }
}
