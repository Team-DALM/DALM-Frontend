import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../app/theme/dalm_colors.dart';
import '../../../app/theme/dalm_theme.dart';
import '../../../app/theme/dalm_typography.dart';
import '../dalm_photo_frame.dart';

const _photo = AssetImage('assets/images/matching_placeholder.png');

Widget _previewFrame(Widget child) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: DalmTheme.light,
    home: Scaffold(
      backgroundColor: DalmColors.background,
      body: Center(child: child),
    ),
  );
}

@Preview(name: '기본 사진', group: 'DalmPhotoFrame', size: Size(390, 360))
Widget dalmPhotoFramePreview() {
  return _previewFrame(
    const SizedBox(
      width: 200,
      child: DalmPhotoFrame(image: _photo, semanticLabel: '창가에서 바라본 오늘의 장면'),
    ),
  );
}

@Preview(name: '오버레이', group: 'DalmPhotoFrame', size: Size(390, 460))
Widget dalmPhotoFrameOverlayPreview() {
  return _previewFrame(
    SizedBox(
      width: 280,
      child: DalmPhotoFrame(
        image: _photo,
        semanticLabel: '분석 중인 오늘의 장면',
        overlay: ColoredBox(
          color: DalmColors.overlay,
          child: Center(
            child: Text(
              '장면을 읽는 중',
              style: DalmTypography.caption.copyWith(
                color: DalmColors.textInverse,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
