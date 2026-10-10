import 'package:dio/dio.dart';

import '../error/network_exception.dart';

Future<T> executeApiCall<T>(Future<T> Function() request) async {
  try {
    return await request();
  } on DioException catch (error) {
    throw NetworkException.fromDioException(error);
  }
}
