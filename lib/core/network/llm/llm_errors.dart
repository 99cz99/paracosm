import 'package:dio/dio.dart';

import '../../utils/app_exception.dart';

/// Maps a dio failure into a user-friendly [LlmException].
LlmException mapDioException(DioException e) {
  final status = e.response?.statusCode;
  final data = e.response?.data;

  if (e.type == DioExceptionType.cancel) {
    return LlmException('已取消', code: 'cancelled');
  }
  if (e.type == DioExceptionType.connectionTimeout ||
      e.type == DioExceptionType.sendTimeout ||
      e.type == DioExceptionType.receiveTimeout) {
    return LlmException('连接超时，请检查网络或 baseUrl', code: 'timeout');
  }
  if (e.type == DioExceptionType.connectionError) {
    return LlmException('网络连接失败，请检查网络', code: 'connection');
  }
  if (status == 401) {
    return LlmException('API Key 无效（401）', code: '401');
  }
  if (status == 429) {
    return LlmException('请求过于频繁（429），请稍后重试', code: '429');
  }
  if (status != null) {
    final extracted = _extractMessage(data);
    return LlmException(extracted ?? '请求失败（HTTP $status）', code: '$status');
  }
  return LlmException(e.message ?? '请求失败', code: null);
}

String? _extractMessage(dynamic data) {
  if (data is Map) {
    final error = data['error'];
    if (error is Map && error['message'] is String) {
      return error['message'] as String;
    }
    if (data['message'] is String) {
      return data['message'] as String;
    }
  }
  return null;
}
