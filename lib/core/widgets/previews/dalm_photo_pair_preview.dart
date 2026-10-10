import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

import '../../../app/theme/dalm_colors.dart';
import '../../../app/theme/dalm_theme.dart';
import '../dalm_photo_pair.dart';

const _leftPhoto = NetworkImage('https://picsum.photos/id/1060/600/800');
const _rightPhoto = NetworkImage('https://picsum.photos/id/1040/600/800');

Widget _previewFrame(DalmPhotoPair photoPair) {
  return MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: DalmTheme.light,
    home: Scaffold(
      backgroundColor: DalmColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: SizedBox(width: 328, child: photoPair),
        ),
      ),
    ),
  );
}

@Preview(name: '매칭 중', group: 'DalmPhotoPair', size: Size(390, 300))
Widget dalmPhotoPairSearchingPreview() {
  return _previewFrame(
    const DalmPhotoPair(
      leftImage: _leftPhoto,
      status: DalmPhotoPairStatus.searching,
    ),
  );
}

@Preview(name: '사진 가림', group: 'DalmPhotoPair', size: Size(390, 300))
Widget dalmPhotoPairHiddenPreview() {
  return _previewFrame(
    const DalmPhotoPair(
      leftImage: _leftPhoto,
      rightImage: _rightPhoto,
      status: DalmPhotoPairStatus.hidden,
    ),
  );
}

@Preview(name: '사진 공개', group: 'DalmPhotoPair', size: Size(390, 300))
Widget dalmPhotoPairRevealedPreview() {
  return _previewFrame(
    const DalmPhotoPair(
      leftImage: _leftPhoto,
      rightImage: _rightPhoto,
      status: DalmPhotoPairStatus.revealed,
    ),
  );
}
