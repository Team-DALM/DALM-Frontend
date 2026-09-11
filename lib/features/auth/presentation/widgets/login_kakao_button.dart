import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class LoginKakaoButton extends StatelessWidget {
  const LoginKakaoButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: FilledButton(
        // 로그인 중 버튼 비활성화하여 중복 요청 방지
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: DalmColors.kakao,
          disabledBackgroundColor: DalmColors.kakao,
          foregroundColor: DalmColors.kakaoText,
          disabledForegroundColor: DalmColors.kakaoText,
          elevation: 0,
          textStyle: DalmTypography.button,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        ),
        // 로그인 중 로딩 표시
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: DalmColors.kakaoText,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/icons/login_kakao.png',
                    width: 26,
                    height: 24,
                  ),
                  const SizedBox(width: 22.5),
                  const Text('카카오로 계속하기'),
                ],
              ),
      ),
    );
  }
}
