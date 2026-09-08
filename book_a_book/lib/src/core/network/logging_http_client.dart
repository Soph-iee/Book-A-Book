import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// An [http.Client] that logs every request and response to the console while
/// the app runs in debug builds. It wraps a real client and delegates all work
/// to it, so Supabase (the SDK (Software Development Kit) used here) and the
/// rest of the app are unaware it exists.
///
/// Logged details:
///  - outgoing requests: method, URL (Uniform Resource Locator), headers (auth
///    secrets redacted), and body.
///  - incoming responses: status code, latency, headers, and body.
///  - failures: timeouts, network errors, and non-2xx server responses, each
///    with a stack trace.
///
/// In release builds [send] short-circuits to the inner client, so no logging
/// or allocation occurs in production.
class LoggingHttpClient extends http.BaseClient {
  LoggingHttpClient([http.Client? inner, this.timeout])
    : _inner = inner ?? http.Client();

  final http.Client _inner;

  /// Optional hard timeout applied on top of the inner client. When null, the
  /// inner client's own behaviour is preserved.
  final Duration? timeout;

  static const int _maxBodyChars = 2000;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (!kDebugMode) return _inner.send(request);

    final stopwatch = Stopwatch()..start();
    _logRequest(request);

    late final http.StreamedResponse response;
    try {
      final future = _inner.send(request);
      response = timeout == null
          ? await future
          : await future.timeout(timeout!);
    } on TimeoutException catch (error, stackTrace) {
      _logFailure('TIMEOUT', stopwatch.elapsed, error, stackTrace);
      rethrow;
    } catch (error, stackTrace) {
      final label = error is SocketException
          ? 'NETWORK ERROR'
          : 'REQUEST ERROR';
      _logFailure(label, stopwatch.elapsed, error, stackTrace);
      rethrow;
    }

    final latency = stopwatch.elapsed;
    final bytes = await response.stream.toBytes();
    _logResponse(response, bytes, latency);









    

    // Rebuild a streamed response so the body can be read by both the logger
    // and the original caller (Supabase).
    return http.StreamedResponse(
      Stream.value(bytes),
      response.statusCode,
      request: response.request,
      headers: response.headers,
      isRedirect: response.isRedirect,
      persistentConnection: response.persistentConnection,
      reasonPhrase: response.reasonPhrase,
    );
  }

  void _logRequest(http.BaseRequest request) {
    final buffer = StringBuffer()
      ..writeln('➡️ ${request.method} ${request.url}');
    _writeHeaders(buffer, request.headers);
    final body = _requestBody(request);
    if (body != null) buffer.writeln('Body: $body');
    log(buffer.toString(), name: 'API');
  }

  void _logResponse(
    http.StreamedResponse response,
    List<int> bytes,
    Duration latency,
  ) {
    final isError = response.statusCode >= 400;
    final arrow = isError ? '❌' : '⬅️';
    final buffer = StringBuffer()
      ..writeln(
        '$arrow ${response.statusCode} ${response.reasonPhrase ?? ''} '
        '(${latency.inMilliseconds} ms)',
      );
    _writeHeaders(buffer, response.headers);
    buffer.writeln('Body: ${_decodeBody(bytes)}');
    log(buffer.toString(), name: 'API', level: isError ? 900 : 0);
  }

  void _logFailure(
    String label,
    Duration latency,
    Object error,
    StackTrace stackTrace,
  ) {
    log(
      '$label after ${latency.inMilliseconds} ms: $error',
      name: 'API',
      level: 1000,
      stackTrace: stackTrace,
    );
  }

  void _writeHeaders(StringBuffer buffer, Map<String, String> headers) {
    for (final entry in headers.entries) {
      final value = _isSensitive(entry.key) ? '•••• (redacted)' : entry.value;
      buffer.writeln('${entry.key}: $value');
    }
  }

  String? _requestBody(http.BaseRequest request) {
    if (request is http.Request) {
      return request.body.isEmpty ? null : _truncate(request.body);
    }
    if (request is http.MultipartRequest) {
      return 'multipart: ${request.fields.length} fields, '
          '${request.files.length} files';
    }
    return null;
  }

  String _decodeBody(List<int> bytes) {
    if (bytes.isEmpty) return '(empty)';
    try {
      return _truncate(utf8.decode(bytes, allowMalformed: true));
    } on Object {
      return '(${bytes.length} bytes of binary data)';
    }
  }

  String _truncate(String text) => text.length <= _maxBodyChars
      ? text
      : '${text.substring(0, _maxBodyChars)}… (truncated)';

  bool _isSensitive(String header) {
    final lower = header.toLowerCase();
    return lower == 'authorization' || lower == 'apikey';
  }

  @override
  void close() => _inner.close();
}
