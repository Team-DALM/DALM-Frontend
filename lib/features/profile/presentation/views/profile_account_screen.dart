import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/storage/token_storage_provider.dart';
import 'package:dalm/core/widgets/dalm_app_bar.dart';
import 'package:dalm/features/profile/presentation/widgets/account/profile_account_menu.dart';
import 'package:dalm/features/profile/presentation/widgets/account/profile_identity_card.dart';
import 'package:dalm/features/profile/presentation/widgets/account/profile_login_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class ProfileAccountScreen extends ConsumerStatefulWidget {
  const ProfileAccountScreen({super.key});

  @override
  ConsumerState<ProfileAccountScreen> createState() =>
      _ProfileAccountScreenState();
}

class _ProfileAccountScreenState extends ConsumerState<ProfileAccountScreen> {
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);
    await ref.read(tokenStorageProvider).clearTokens();

    if (mounted) context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DalmColors.background,
      appBar: DalmAppBar(
        title: '계정 관리',
        showBackButton: true,
        dividerIndent: 20,
        titleStyle: DalmTypography.bodyBold.copyWith(
          color: DalmColors.textPrimary,
          fontSize: 14,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ProfileIdentityCard(),
            const SizedBox(height: 26),
            const _SectionLabel('로그인 정보'),
            const SizedBox(height: 14),
            const ProfileLoginCard(),
            const SizedBox(height: 32),
            const _SectionLabel('앱 설정'),
            const SizedBox(height: 14),
            ProfileAccountMenu(
              isLoggingOut: _isLoggingOut,
              onLogout: _logout,
              onTermsTap: () {},
              onDeleteAccount: () {},
            ),
            const SizedBox(height: 38),
            Center(
              child: Text(
                '탈퇴 후 삭제된 기록은 복구할 수 없어요.',
                style: DalmTypography.caption.copyWith(
                  color: DalmColors.textSecondary,
                  fontSize: 9,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: DalmTypography.caption.copyWith(
        color: DalmColors.textWarm,
        fontSize: 10,
      ),
    );
  }
}
