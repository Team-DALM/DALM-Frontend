import 'package:flutter/material.dart';

import 'dalm_palette.dart';

/// UI의 역할을 기준으로 사용하는 DALM 색상 토큰입니다.
abstract final class DalmColors {
  static const background = DalmPalette.cream;
  static const surface = DalmPalette.white;
  static const surfaceMuted = DalmPalette.parchment;
  static const textPrimary = DalmPalette.deepInk;
  static const textSecondary = DalmPalette.secondary;
  static const textDisabled = DalmPalette.disabled;
  static const textInverse = DalmPalette.white;
  static const border = DalmPalette.border;

  static const primaryAction = DalmPalette.deepInk;
  static const secondaryAction = DalmPalette.slateBlue;
  static const emotionalAccent = DalmPalette.gold;
  static const searching = DalmPalette.amber;
  static const matched = DalmPalette.brandBlue;
  static const destructive = DalmPalette.coral;
  static const success = DalmPalette.sage;
  static const kakao = DalmPalette.kakaoYellow;

  static const overlay = Color(0x66000000);
}
