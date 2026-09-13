import 'package:dalm/app/theme/dalm_colors.dart';
import 'package:dalm/app/theme/dalm_theme.dart';
import 'package:dalm/features/photo/presentation/widgets/photo_permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

void _onPreviewPressed() {}

@Preview(name: '기본', group: 'PhotoPermissionDialog', size: Size(390, 844))
Widget photoPermissionDialogPreview() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: DalmTheme.light,
    home: const Scaffold(
      backgroundColor: DalmColors.background,
      body: Center(
        child: PhotoPermissionDialog(
          onAllowAll: _onPreviewPressed,
          onAllowSelected: _onPreviewPressed,
          onDeny: _onPreviewPressed,
        ),
      ),
    ),
  );
}
