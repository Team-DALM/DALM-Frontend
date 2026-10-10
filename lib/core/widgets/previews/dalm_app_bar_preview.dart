import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../app/theme/dalm_theme.dart';
import '../dalm_app_bar.dart';

void _onPreviewPressed() {}

Widget _previewFrame(PreferredSizeWidget appBar) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: DalmTheme.light,
    home: Scaffold(appBar: appBar),
  );
}

@Preview(name: '기본 · 오른쪽 문구', group: 'DalmAppBar', size: Size(390, 100))
Widget dalmAppBarTextActionPreview() {
  return _previewFrame(
    DalmAppBar(
      title: 'PARALLEL',
      actionLabel: '나의 기록',
      onActionPressed: _onPreviewPressed,
    ),
  );
}

@Preview(name: '뒤로 가기 · 더보기', group: 'DalmAppBar', size: Size(390, 100))
Widget dalmAppBarMoreActionPreview() {
  return _previewFrame(
    DalmAppBar(
      title: '두 사진이 닮은 이유',
      showBackButton: true,
      onBackPressed: _onPreviewPressed,
      onMorePressed: _onPreviewPressed,
    ),
  );
}
