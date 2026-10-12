import 'dart:io';
import 'dart:typed_data';

/// 앱이 직접 생성한 사진 임시 파일의 생성과 정리를 담당합니다.
///
/// 갤러리 원본이나 image picker가 반환한 파일은 이 관리자가 삭제하지 않습니다.
abstract final class PhotoTemporaryFileManager {
  static Future<String> createPng(Uint8List bytes) async {
    final file = File(
      '${Directory.systemTemp.path}${Platform.pathSeparator}'
      'dalm_photo_${DateTime.now().microsecondsSinceEpoch}.png',
    );
    await file.writeAsBytes(bytes, flush: true);
    return file.path;
  }

  static Future<void> deleteOwnedFile(String path) async {
    if (!_isOwnedPath(path)) return;

    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } on FileSystemException {
      // 임시 파일 정리 실패는 사용자의 화면 흐름을 막지 않습니다.
    }
  }

  static bool _isOwnedPath(String path) {
    final tempPrefix = '${Directory.systemTemp.path}${Platform.pathSeparator}';
    final fileName = path.startsWith(tempPrefix)
        ? path.substring(tempPrefix.length)
        : '';
    return fileName.startsWith('dalm_photo_') && fileName.endsWith('.png');
  }
}
