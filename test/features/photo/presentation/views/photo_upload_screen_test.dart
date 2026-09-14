import 'package:dalm/app/theme/dalm_theme.dart';
import 'package:dalm/features/photo/data/providers/photo_camera_providers.dart';
import 'package:dalm/features/photo/domain/entities/photo_camera_permission_status.dart';
import 'package:dalm/features/photo/domain/repositories/photo_camera_repository.dart';
import 'package:dalm/features/photo/presentation/views/photo_upload_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('사진 등록 화면에 필요한 콘텐츠를 표시한다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: DalmTheme.light,
          home: const PhotoUploadScreen(),
        ),
      ),
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
      ProviderScope(
        child: MaterialApp(
          theme: DalmTheme.light,
          home: PhotoUploadScreen(
            onCameraPressed: () => cameraPressed = true,
            onGalleryPressed: () => galleryPressed = true,
          ),
        ),
      ),
    );

    await tester.tap(find.text('카메라로 촬영하기'));
    await tester.ensureVisible(find.text('앨범에서 선택하기'));
    await tester.tap(find.text('앨범에서 선택하기'));

    expect(cameraPressed, isTrue);
    expect(galleryPressed, isTrue);
  });

  testWidgets('앨범 선택 시 사진 접근 권한 안내를 표시한다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: DalmTheme.light,
          home: const PhotoUploadScreen(),
        ),
      ),
    );

    await tester.ensureVisible(find.text('앨범에서 선택하기'));
    await tester.tap(find.text('앨범에서 선택하기'));
    await tester.pumpAndSettle();

    expect(find.text('사진 접근 권한이 필요해요'), findsOneWidget);
    expect(find.text('모든 사진 허용'), findsOneWidget);
    expect(find.text('선택한 사진만 허용'), findsOneWidget);
    expect(find.text('지금은 허용하지 않기'), findsOneWidget);
  });

  testWidgets('카메라 선택 시 카메라 접근 권한 안내를 표시한다', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: DalmTheme.light,
          home: const PhotoUploadScreen(),
        ),
      ),
    );

    await tester.tap(find.text('카메라로 촬영하기'));
    await tester.pumpAndSettle();

    expect(find.text('카메라 사용 권한이 필요해요'), findsOneWidget);
    expect(find.text('카메라 사용 허용'), findsOneWidget);
    expect(find.text('지금은 허용하지 않기'), findsOneWidget);
  });

  testWidgets('카메라 권한 허용 후 촬영 결과를 전달한다', (tester) async {
    final repository = _FakePhotoCameraRepository(
      permissionStatus: PhotoCameraPermissionStatus.granted,
      photoPath: '/tmp/today-photo.jpg',
    );
    String? capturedPhotoPath;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          photoCameraRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          theme: DalmTheme.light,
          home: PhotoUploadScreen(
            onPhotoCaptured: (path) => capturedPhotoPath = path,
          ),
        ),
      ),
    );

    await tester.tap(find.text('카메라로 촬영하기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('카메라 사용 허용'));
    await tester.pumpAndSettle();

    expect(repository.permissionRequestCount, 1);
    expect(repository.takePhotoCount, 1);
    expect(capturedPhotoPath, '/tmp/today-photo.jpg');
  });

  testWidgets('카메라 권한이 영구 거부되면 설정 이동을 안내한다', (tester) async {
    final repository = _FakePhotoCameraRepository(
      permissionStatus: PhotoCameraPermissionStatus.permanentlyDenied,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          photoCameraRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          theme: DalmTheme.light,
          home: const PhotoUploadScreen(),
        ),
      ),
    );

    await tester.tap(find.text('카메라로 촬영하기'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('카메라 사용 허용'));
    await tester.pumpAndSettle();

    expect(find.text('설정에서 카메라를 허용해 주세요'), findsOneWidget);
    expect(repository.takePhotoCount, 0);

    final openSettingsButton = find.widgetWithText(FilledButton, '설정 열기');
    final cancelButton = find.widgetWithText(FilledButton, '취소');
    expect(tester.getSize(openSettingsButton), tester.getSize(cancelButton));
    expect(
      tester.getTopLeft(openSettingsButton).dy,
      lessThan(tester.getTopLeft(cancelButton).dy),
    );

    await tester.tap(find.text('설정 열기'));
    await tester.pumpAndSettle();

    expect(repository.openSettingsCount, 1);
  });
}

final class _FakePhotoCameraRepository implements PhotoCameraRepository {
  _FakePhotoCameraRepository({required this.permissionStatus, this.photoPath});

  final PhotoCameraPermissionStatus permissionStatus;
  final String? photoPath;

  int permissionRequestCount = 0;
  int takePhotoCount = 0;
  int openSettingsCount = 0;

  @override
  Future<PhotoCameraPermissionStatus> requestPermission() async {
    permissionRequestCount += 1;
    return permissionStatus;
  }

  @override
  Future<String?> takePhoto() async {
    takePhotoCount += 1;
    return photoPath;
  }

  @override
  Future<bool> openSettings() async {
    openSettingsCount += 1;
    return true;
  }
}
