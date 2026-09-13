import 'package:dalm/app/theme/dalm_theme.dart';
import 'package:dalm/features/photo/presentation/views/photo_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

void _onPreviewPressed() {}

@Preview(name: '기본', group: 'PhotoUploadScreen', size: Size(390, 844))
Widget photoUploadScreenPreview() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: DalmTheme.light,
    home: PhotoUploadScreen(
      onCameraPressed: _onPreviewPressed,
      onGalleryPressed: _onPreviewPressed,
    ),
  );
}
