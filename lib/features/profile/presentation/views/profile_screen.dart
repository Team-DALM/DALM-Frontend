import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/storage/token_storage_provider.dart';
import 'package:dalm/core/widgets/dalm_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);

    try {
      // 저장된 로그인 토큰 삭제
      await ref.read(tokenStorageProvider).clearTokens();

      if (!mounted) return;

      // 로그아웃 성공 시 로그인 화면으로 이동
      context.go(AppRoutes.login);
    } on Object {
      if (!mounted) return;

      setState(() => _isLoggingOut = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('로그아웃에 실패했어요. 다시 시도해주세요.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DalmColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 32, 24, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '마이페이지',
                style: DalmTypography.serifHeadline.copyWith(
                  color: DalmColors.textPrimary,
                ),
              ),
              const Spacer(),
              DalmButton(
                label: '로그아웃',
                onPressed: _logout,
                variant: DalmButtonVariant.secondary,
                isLoading: _isLoggingOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
