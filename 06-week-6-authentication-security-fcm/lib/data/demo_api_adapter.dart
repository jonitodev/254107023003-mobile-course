import 'dart:typed_data';

import 'package:dio/dio.dart';

/// Local transport for the retry exercise; no request leaves the device.
class DemoApiAdapter implements HttpClientAdapter {
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final renewed = options.extra['authRetried'] == true;
    return ResponseBody.fromString(
      renewed ? '{"message":"Refresh berhasil, retry 200 OK"}' : '{}',
      renewed ? 200 : 401,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
