import 'dart:convert';
import 'dart:io';

import 'package:dalm/features/photo/presentation/views/photo_crop_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDirectory;
  late File imageFile;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp('dalm_crop_test_');
    imageFile = File('${tempDirectory.path}${Platform.pathSeparator}photo.png');
    await imageFile.writeAsBytes(
      base64Decode(
        'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=',
      ),
    );
  });

  tearDown(() async {
    await tempDirectory.delete(recursive: true);
  });

  testWidgets('4:5 사진 맞추기 화면을 표시한다', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: PhotoCropScreen(imagePath: imageFile.path)),
    );
    await tester.pumpAndSettle();

    expect(find.text('사진 맞추기'), findsOneWidget);
    expect(find.text('다음'), findsOneWidget);
    expect(find.text('4 : 5'), findsOneWidget);
    expect(find.text('초기화'), findsOneWidget);
    expect(find.text('회전'), findsOneWidget);

    final viewportSize = tester.getSize(
      find.byKey(const Key('photoCropViewport')),
    );
    expect(viewportSize.width / viewportSize.height, closeTo(4 / 5, 0.001));
  });
}
