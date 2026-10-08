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
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

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
    final headerSize = tester.getSize(find.byKey(const Key('photoCropHeader')));
    expect(headerSize.height, 80);
    expect(viewportSize.width, 330);
    expect(viewportSize.height, 412.5);
    expect(viewportSize.width / viewportSize.height, closeTo(4 / 5, 0.001));
  });

  testWidgets('좁은 화면에서도 사진 좌우 여백을 30으로 유지한다', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(360, 800);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      MaterialApp(home: PhotoCropScreen(imagePath: imageFile.path)),
    );
    await tester.pumpAndSettle();

    final areaFinder = find.byKey(const Key('photoCropArea'));
    final viewportFinder = find.byKey(const Key('photoCropViewport'));
    final areaLeft = tester.getTopLeft(areaFinder).dx;
    final areaRight = tester.getTopRight(areaFinder).dx;
    final viewportLeft = tester.getTopLeft(viewportFinder).dx;
    final viewportRight = tester.getTopRight(viewportFinder).dx;

    expect(viewportLeft - areaLeft, 30);
    expect(areaRight - viewportRight, 30);
  });

  testWidgets('사진을 불러오지 못하면 다음 버튼을 비활성화한다', (tester) async {
    final missingPath =
        '${tempDirectory.path}${Platform.pathSeparator}missing.png';

    await tester.pumpWidget(
      MaterialApp(home: PhotoCropScreen(imagePath: missingPath)),
    );
    await tester.pumpAndSettle();

    final nextButton = tester.widget<TextButton>(
      find.widgetWithText(TextButton, '다음'),
    );
    expect(nextButton.onPressed, isNull);
  });
}
