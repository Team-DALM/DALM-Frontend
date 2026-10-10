import 'package:flutter/material.dart';

import '../../app/theme/dalm_colors.dart';
import '../../app/theme/dalm_typography.dart';

/// 버튼의 역할에 맞는 색상과 테두리 스타일을 선택합니다.
enum DalmButtonVariant {
  /// 주요 행동: 검은 배경과 흰 글씨를 사용합니다.
  primary,

  /// 감성적인 주요 행동: 금색 배경과 검은 글씨를 사용합니다.
  accent,

  /// 보조 행동: 흰 배경, 검은 글씨, 테두리를 사용합니다.
  secondary,

  /// 삭제·차단 등 위험 행동: 붉은 배경과 흰 글씨를 사용합니다.
  destructive,
}

class DalmButton extends StatelessWidget {
  const DalmButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = DalmButtonVariant.primary,
    this.isLoading = false,
  });

  final String label;

  final VoidCallback? onPressed;

  final DalmButtonVariant variant;

  /// `true`이면 로딩 표시를 보여주고 중복 클릭을 막습니다.
  final bool isLoading;

  static const double _height = 56;
  static const double _borderRadius = 6;
  static const double _horizontalPadding = 20;
  static const double _loadingIndicatorSize = 20;

  Color get _backgroundColor {
    return switch (variant) {
      DalmButtonVariant.primary => DalmColors.primaryAction,
      DalmButtonVariant.accent => DalmColors.accentAction,
      DalmButtonVariant.secondary => DalmColors.surface,
      DalmButtonVariant.destructive => DalmColors.destructive,
    };
  }

  Color get _foregroundColor {
    return switch (variant) {
      DalmButtonVariant.primary ||
      DalmButtonVariant.destructive => DalmColors.textInverse,
      DalmButtonVariant.accent ||
      DalmButtonVariant.secondary => DalmColors.textPrimary,
    };
  }

  BorderSide get _borderSide {
    return switch (variant) {
      DalmButtonVariant.secondary => const BorderSide(color: DalmColors.border),
      _ => BorderSide.none,
    };
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중에는 동작만 잠그고 현재 variant 색상은 유지합니다.
    final disabledBackgroundColor = isLoading
        ? _backgroundColor
        : DalmColors.surfaceMuted;
    final disabledForegroundColor = isLoading
        ? _foregroundColor
        : DalmColors.textDisabled;

    return SizedBox(
      // 너비는 고정하지 않고 부모가 제공하는 영역을 모두 채웁니다.
      width: double.infinity,
      height: _height,
      child: FilledButton(
        // Material 버튼은 onPressed가 null일 때 클릭을 허용하지 않습니다.
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          minimumSize: const Size(0, _height),
          backgroundColor: _backgroundColor,
          foregroundColor: _foregroundColor,
          disabledBackgroundColor: disabledBackgroundColor,
          disabledForegroundColor: disabledForegroundColor,
          elevation: 0,
          textStyle: DalmTypography.button,
          padding: const EdgeInsets.symmetric(horizontal: _horizontalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(_borderRadius),
            side: _borderSide,
          ),
        ),
        child: isLoading
            ? SizedBox.square(
                dimension: _loadingIndicatorSize,
                child: CircularProgressIndicator(
                  color: _foregroundColor,
                  strokeWidth: 2,
                  semanticsLabel: '로딩 중',
                ),
              )
            : Text(label, textAlign: TextAlign.center),
      ),
    );
  }
}
