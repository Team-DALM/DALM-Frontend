import 'package:dalm/app/router/app_routes.dart';
import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_typography.dart';
import 'package:dalm/core/config/app_config.dart';
import 'package:dalm/core/widgets/dalm_overlapping_photos.dart';
import 'package:dalm/core/widgets/dalm_progress_indicator.dart';
import 'package:dalm/features/auth/presentation/widgets/login_kakao_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key, this.onTermsPressed, this.onPrivacyPressed});

  final VoidCallback? onTermsPressed;
  final VoidCallback? onPrivacyPressed;

  Future<void> _openExternalLink(
    BuildContext context, {
    required Uri uri,
    VoidCallback? callback,
  }) async {
    if (callback != null) {
      callback();
      return;
    }

    try {
      if (await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        return;
      }
    } on Exception {
      // 아래의 공통 안내 메시지를 표시합니다.
    }

    if (!context.mounted) return;

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('페이지를 열지 못했습니다.')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(20, 24, 28, 0),
                        child: _LoginHeader(),
                      ),
                      const SizedBox(height: 51),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: Text(
                          '당신의 하루가\n나란해질 준비를 해요.',
                          style: DalmTypography.serifHeadline.copyWith(
                            fontSize: 27,
                            color: DalmColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 46),
                      const Center(
                        child: SizedBox(
                          width: 350,
                          height: 336,
                          child: DalmOverlappingPhotos(
                            firstImage: AssetImage(
                              'assets/images/onboarding_bus_1.png',
                            ),
                            secondImage: AssetImage(
                              'assets/images/onboarding_bus_2.png',
                            ),
                            photoWidth: 218,
                            photoHeight: 290,
                            horizontalOffset: 132,
                            verticalOffset: 46,
                            firstLabel: 'DAY 01',
                            secondLabel: 'WITHIN 07 DAYS',
                          ),
                        ),
                      ),
                      const SizedBox(height: 43),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: DalmProgressIndicator.daily(currentDay: 7),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                        child: LoginKakaoButton(
                          onPressed: () {
                            context.go(AppRoutes.home);
                          },
                        ),
                      ),
                      const SizedBox(height: 14),
                      Center(
                        child: _TermsConsentText(
                          onTermsPressed: () => _openExternalLink(
                            context,
                            uri: AppConfig.termsOfServiceUri,
                            callback: onTermsPressed,
                          ),
                          onPrivacyPressed: () => _openExternalLink(
                            context,
                            uri: AppConfig.privacyPolicyUri,
                            callback: onPrivacyPressed,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LoginHeader extends StatelessWidget {
  const _LoginHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'DALM',
          style: DalmTypography.caption.copyWith(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: DalmColors.textPrimary,
          ),
        ),
        const SizedBox(width: 44, child: _ParallelLines()),
      ],
    );
  }
}

class _ParallelLines extends StatelessWidget {
  const _ParallelLines();

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          width: 44,
          height: 1,
          child: ColoredBox(color: DalmColors.secondaryAction),
        ),
        SizedBox(height: 6),
        SizedBox(
          width: 36,
          height: 1,
          child: ColoredBox(color: DalmColors.emotionalAccent),
        ),
      ],
    );
  }
}

class _TermsConsentText extends StatelessWidget {
  const _TermsConsentText({
    required this.onTermsPressed,
    required this.onPrivacyPressed,
  });

  final VoidCallback onTermsPressed;
  final VoidCallback onPrivacyPressed;

  static final _textStyle = DalmTypography.caption.copyWith(
    fontSize: 9,
    height: 1.5,
    color: DalmColors.textSecondary,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('계속하면 PARALLEL의 ', style: _textStyle),
            _ConsentLink(
              label: '서비스 이용약관',
              onPressed: onTermsPressed,
              style: _textStyle,
            ),
            Text(' 및', style: _textStyle),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _ConsentLink(
              label: '개인정보 처리방침',
              onPressed: onPrivacyPressed,
              style: _textStyle,
            ),
            Text('에 동의하게 됩니다.', style: _textStyle),
          ],
        ),
      ],
    );
  }
}

class _ConsentLink extends StatelessWidget {
  const _ConsentLink({
    required this.label,
    required this.onPressed,
    required this.style,
  });

  final String label;
  final VoidCallback onPressed;
  final TextStyle style;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      link: true,
      label: '$label 열기',
      child: InkWell(
        onTap: onPressed,
        child: Text(
          label,
          style: style.copyWith(
            decoration: TextDecoration.underline,
            decorationColor: DalmColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
