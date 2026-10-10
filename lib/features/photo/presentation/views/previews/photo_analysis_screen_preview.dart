import 'package:dalm/app/theme/dalm_theme.dart';
import 'package:dalm/features/photo/data/providers/photo_analysis_providers.dart';
import 'package:dalm/features/photo/data/repositories/fake_photo_analysis_repository.dart';
import 'package:dalm/features/photo/presentation/views/photo_analysis_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/widget_previews.dart';

@Preview(name: '분석 진행', group: 'PhotoAnalysisScreen', size: Size(390, 844))
Widget photoAnalysisScreenPreview() {
  return ProviderScope(
    overrides: [
      photoAnalysisRepositoryProvider.overrideWithValue(
        const FakePhotoAnalysisRepository(),
      ),
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: DalmTheme.light,
      home: const PhotoAnalysisScreen(
        imagePath: '',
        photoId: 'preview-photo-id',
        deleteImageOnDispose: false,
      ),
    ),
  );
}
