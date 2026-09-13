import 'package:dalm/app/theme/dalm_theme.dart';
import 'package:dalm/features/photo/presentation/views/photo_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('사진 등록 화면에 필요한 콘텐츠를 표시한다', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: DalmTheme.light, home: const PhotoUploadScreen()),
    );

    expect(find.text('오늘의 사진'), findsOneWidget);
    expect(find.text('사진 한 장'), findsOneWidget);
    expect(find.text('4:5 세로 비율로 기록돼요.'), findsOneWidget);
    expect(find.text('카메라로 촬영하기'), findsOneWidget);
    expect(find.text('앨범에서 선택하기'), findsOneWidget);
    expect(find.text('사진은 공개 피드에 게시되지 않아요.'), findsOneWidget);
  });

  testWidgets('카메라와 앨범 선택 콜백을 호출한다', (tester) async {
    var cameraPressed = false;
    var galleryPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        theme: DalmTheme.light,
        home: PhotoUploadScreen(
          onCameraPressed: () => cameraPressed = true,
          onGalleryPressed: () => galleryPressed = true,
        ),
      ),
    );

    await tester.tap(find.text('카메라로 촬영하기'));
    await tester.tap(find.text('앨범에서 선택하기'));

    expect(cameraPressed, isTrue);
    expect(galleryPressed, isTrue);
  });
}
