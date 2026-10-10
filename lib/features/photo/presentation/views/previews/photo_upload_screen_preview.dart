import 'package:dalm/app/theme/dalm_theme.dart';
import 'package:dalm/features/photo/presentation/views/photo_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widget_previews.dart';

void _onPreviewPressed() {}

/// 사진 등록 화면 미리보기
@Preview(name: '기본', group: 'PhotoUploadScreen', size: Size(390, 844))
Widget photoUploadScreenPreview() {
  return ProviderScope(
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: DalmTheme.light,
      home: PhotoUploadScreen(
        onCameraPressed: _onPreviewPressed,
        onGalleryPressed: _onPreviewPressed,
      ),
    ),
  );
}
