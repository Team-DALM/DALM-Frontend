import 'dart:convert';
import 'dart:io';

import 'package:dalm/features/photo/presentation/views/photo_rejected_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDirectory;
  late File imageFile;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'dalm_rejected_test_',
    );
    imageFile = File('${tempDirectory.path}${Platform.pathSeparator}photo.png');
    await imageFile.writeAsBytes(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
      ),
    );
  });

  tearDown(() async {
    if (await tempDirectory.exists()) {
      await tempDirectory.delete(recursive: true);
    }
  });

  testWidgets('사진 검증 실패 화면을 표시한다', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: PhotoRejectedScreen(
          imagePath: imageFile.path,
          photoId: 'test-photo-id',
          deleteImageOnDispose: false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('사진을 다시 골라주세요'), findsOneWidget);
    expect(find.text('장면을 충분히 읽지 못했어요.'), findsOneWidget);
    expect(find.text('빛 정보 부족'), findsOneWidget);
    expect(find.text('피사체 인식 어려움'), findsOneWidget);
    expect(find.text('낮은 선명도'), findsOneWidget);
    expect(find.text('다른 사진 선택하기'), findsOneWidget);
    expect(find.text('오늘은 나중에 남기기'), findsOneWidget);

    final imageSize = tester.getSize(
      find.byKey(const Key('photoRejectedImage')),
    );
    expect(imageSize, const Size(240, 300));
    expect(tester.takeException(), isNull);
  });
}
