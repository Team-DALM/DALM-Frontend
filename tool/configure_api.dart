import 'dart:io';

void main(List<String> args) {
  if (args.length != 1) {
    stderr.writeln('Usage: dart run tool/configure_api.dart <API_BASE_URL>');
    exitCode = 64;
    return;
  }
  final uri = Uri.tryParse(args.single);
  if (uri == null ||
      !['http', 'https'].contains(uri.scheme) ||
      uri.host.isEmpty ||
      uri.userInfo.isNotEmpty ||
      uri.hasQuery ||
      uri.hasFragment ||
      !RegExp(r'^[a-zA-Z0-9.:-]+$').hasMatch(uri.host)) {
    stderr.writeln('Supply an HTTP(S) API URL without credentials or query.');
    exitCode = 64;
    return;
  }
  final envFile = File('.env');
  final source = envFile.existsSync()
      ? envFile.readAsStringSync()
      : File('.env.example').readAsStringSync();
  final lines = source
      .split('\n')
      .where(
        (line) =>
            !line.startsWith('API_BASE_URL=') &&
            !line.startsWith('DALM_HTTP_HOST='),
      );
  final baseUrl = uri.toString().endsWith('/') ? '$uri' : '$uri/';
  final httpHost = uri.scheme == 'http' ? uri.host : 'localhost';
  envFile.writeAsStringSync(
    '${lines.join('\n').trimRight()}\n'
    'API_BASE_URL=$baseUrl\nDALM_HTTP_HOST=$httpHost\n',
  );
  stdout.writeln('API URL configured; existing login keys preserved.');
}
