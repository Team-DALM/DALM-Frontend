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

  testWidgets('앨범 선택 시 사진 접근 권한 안내를 표시한다', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: DalmTheme.light, home: const PhotoUploadScreen()),
    );

    await tester.tap(find.text('앨범에서 선택하기'));
    await tester.pumpAndSettle();

    expect(find.text('사진 접근 권한이 필요해요'), findsOneWidget);
    expect(find.text('모든 사진 허용'), findsOneWidget);
    expect(find.text('선택한 사진만 허용'), findsOneWidget);
    expect(find.text('지금은 허용하지 않기'), findsOneWidget);
  });

  testWidgets('카메라 선택 시 카메라 접근 권한 안내를 표시한다', (tester) async {
    await tester.pumpWidget(
      MaterialApp(theme: DalmTheme.light, home: const PhotoUploadScreen()),
    );

    await tester.tap(find.text('카메라로 촬영하기'));
    await tester.pumpAndSettle();

    expect(find.text('카메라 사용 권한이 필요해요'), findsOneWidget);
    expect(find.text('카메라 사용 허용'), findsOneWidget);
    expect(find.text('지금은 허용하지 않기'), findsOneWidget);
  });
}
