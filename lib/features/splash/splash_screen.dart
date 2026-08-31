import 'package:dalm/app/router/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _moveToOnboarding();
  }

  Future<void> _moveToOnboarding() async {
    await Future<void>.delayed(const Duration(seconds: 2)); // 2초 뒤

    if (!mounted) return;

    context.go(AppRoutes.onboarding); // 온보딩으로 넘어감
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('스플래시'),
      ),
    );
  }
}
