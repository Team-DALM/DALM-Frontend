import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:flutter/material.dart';

class LoginAppleButton extends StatelessWidget {
  const LoginAppleButton({
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
          backgroundColor: Colors.black,
          disabledBackgroundColor: Colors.black,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white,
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
                  color: Colors.white,
                ),
              )
            : const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.apple, size: 24),
                  SizedBox(width: 18),
                  Text('Apple로 계속하기'),
                ],
              ),
      ),
    );
  }
}
