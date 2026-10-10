import 'dart:convert';
import 'dart:io';

import 'package:dalm/features/photo/presentation/views/photo_upload_failure_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late Directory tempDirectory;
  late File imageFile;

  setUp(() async {
    tempDirectory = await Directory.systemTemp.createTemp(
      'dalm_upload_failure_test_',
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

  testWidgets('사진 업로드 실패 화면을 표시한다', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: PhotoUploadFailureScreen(
            imagePath: imageFile.path,
            deleteImageOnDispose: false,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('업로드하지 못했어요'), findsOneWidget);
    expect(find.text('사진을 남기지 못했어요.'), findsOneWidget);
    expect(find.textContaining('연결이 불안정해'), findsOneWidget);
    expect(find.text('다시 시도하기'), findsOneWidget);
    expect(find.text('나중에'), findsOneWidget);

    final imageSize = tester.getSize(
      find.byKey(const Key('photoUploadFailureImage')),
    );
    expect(imageSize, const Size(280, 350));
    expect(tester.takeException(), isNull);
  });
}
