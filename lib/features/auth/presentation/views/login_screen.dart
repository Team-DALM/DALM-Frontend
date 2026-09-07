import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/features/auth/presentation/widgets/login_kakao_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Expanded(child: Center(child: Text('로그인'))),
              LoginKakaoButton(
                onPressed: () {
                  context.go(AppRoutes.home);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
