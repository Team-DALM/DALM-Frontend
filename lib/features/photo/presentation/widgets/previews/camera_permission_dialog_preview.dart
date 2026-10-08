import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_theme.dart';
import 'package:dalm/features/photo/presentation/widgets/camera_permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

void _onPreviewPressed() {}

/// 카메라 권한 안내 다이얼로그 미리보기
@Preview(name: '기본', group: 'CameraPermissionDialog', size: Size(390, 844))
Widget cameraPermissionDialogPreview() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: DalmTheme.light,
    home: const Scaffold(
      backgroundColor: DalmColors.background,
      body: Center(
        child: CameraPermissionDialog(
          onAllow: _onPreviewPressed,
          onDeny: _onPreviewPressed,
        ),
      ),
    ),
  );
}
