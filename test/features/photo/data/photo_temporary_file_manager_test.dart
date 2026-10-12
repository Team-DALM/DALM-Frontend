import 'dart:io';
import 'dart:typed_data';

import 'package:dalm/features/photo/data/services/photo_temporary_file_manager.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('앱이 생성한 크롭 파일을 만들고 삭제한다', () async {
    final path = await PhotoTemporaryFileManager.createPng(
      Uint8List.fromList([1, 2, 3]),
    );
    final file = File(path);
    addTearDown(() async {
      if (await file.exists()) await file.delete();
    });

    expect(await file.exists(), isTrue);

    await PhotoTemporaryFileManager.deleteOwnedFile(path);

    expect(await file.exists(), isFalse);
  });

  test('관리 대상이 아닌 파일은 삭제하지 않는다', () async {
    final directory = await Directory.systemTemp.createTemp('photo_source_');
    final file = File('${directory.path}${Platform.pathSeparator}source.png');
    await file.writeAsBytes([1]);
    addTearDown(() => directory.delete(recursive: true));

    await PhotoTemporaryFileManager.deleteOwnedFile(file.path);

    expect(await file.exists(), isTrue);
  });
}
