import 'dart:convert';
import 'dart:io';

import 'package:dalm/features/photo/presentation/views/photo_record_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDirectory;
  late File imageFile;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('dalm_record_test_');
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

  testWidgets('사진 분석 완료 화면을 표시한다', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(
        home: PhotoRecordScreen(
          imagePath: imageFile.path,
          photoId: 'test-photo-id',
          deleteImageOnDispose: false,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('오늘의 기록'), findsOneWidget);
    expect(find.text('오늘의 장면을 남겼어요.'), findsOneWidget);
    expect(find.text('평행한 순간 탐색 시작'), findsOneWidget);
    expect(find.text('DAY 1 / 7'), findsOneWidget);
    expect(find.text('오늘 화면으로 돌아가기'), findsOneWidget);
    expect(find.text('내 순간 자세히 보기'), findsOneWidget);

    final imageSize = tester.getSize(find.byKey(const Key('photoRecordImage')));
    expect(imageSize, const Size(200, 250));
    expect(tester.takeException(), isNull);
  });
}
