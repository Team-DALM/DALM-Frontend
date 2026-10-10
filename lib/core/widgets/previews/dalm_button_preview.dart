import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../app/theme/dalm_colors.dart';
import '../../../app/theme/dalm_theme.dart';
import '../dalm_button.dart';

void _onPreviewPressed() {}

Widget _previewFrame() {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: DalmTheme.light,
    home: Scaffold(
      backgroundColor: DalmColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            DalmButton(label: '다음', onPressed: _onPreviewPressed),
            const SizedBox(height: 12),
            DalmButton(
              label: '이 엽서 보내기',
              onPressed: _onPreviewPressed,
              variant: DalmButtonVariant.accent,
            ),
            const SizedBox(height: 12),
            DalmButton(
              label: '삭제하기',
              onPressed: _onPreviewPressed,
              variant: DalmButtonVariant.destructive,
            ),
            const SizedBox(height: 12),
            DalmButton(
              label: '처리 중',
              onPressed: _onPreviewPressed,
              isLoading: true,
            ),
            const SizedBox(height: 12),
            const DalmButton(label: '비활성화', onPressed: null),
          ],
        ),
      ),
    ),
  );
}

@Preview(
  name: 'Buttons · Loading · Disabled',
  group: 'DalmButton',
  size: Size(390, 408),
)
Widget dalmButtonPreview() {
  return _previewFrame();
}
