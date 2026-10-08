import 'dart:typed_data';

import 'package:campus_notify/data/api_client.dart';
import 'package:campus_notify/data/auth_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'auth_push_test.dart' show FakeTokenStore;

class CountingAuth extends AuthRepository {
  int refreshes = 0;
  bool fails = false;

  @override
  Future<String> refresh(String refreshToken) async {
    refreshes++;
    if (fails) throw StateError('Refresh expired');
    return 'renewed-access-token';
  }
}

class SequenceAdapter implements HttpClientAdapter {
  SequenceAdapter(this.statuses);
  final List<int> statuses;
  final List<String?> authorization = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    authorization.add(options.headers['Authorization'] as String?);
    return ResponseBody.fromString(
      '{}',
      statuses.removeAt(0),
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late FakeTokenStore store;
  late CountingAuth auth;
  late Dio dio;
  late bool expired;

  setUp(() {
    store = FakeTokenStore()
      ..access = 'old-token'
      ..refresh = 'refresh-token';
    auth = CountingAuth();
    expired = false;
    dio = buildApiClient(store, auth, onSessionExpired: () => expired = true);
  });
  tearDown(() => dio.close());

  test('401 renews once and retries with new Authorization header', () async {
    final adapter = SequenceAdapter([401, 200]);
    dio.httpClientAdapter = adapter;
    final response = await dio.get<dynamic>('/protected');
    expect(response.statusCode, 200);
    expect(auth.refreshes, 1);
    expect(adapter.authorization, [
      'Bearer old-token',
      'Bearer renewed-access-token',
    ]);
    expect(expired, isFalse);
  });

  test('second 401 stops retry loop and expires session', () async {
    final adapter = SequenceAdapter([401, 401]);
    dio.httpClientAdapter = adapter;
    await expectLater(
      dio.get<dynamic>('/protected'),
      throwsA(isA<DioException>()),
    );
    expect(auth.refreshes, 1);
    expect(adapter.authorization.length, 2);
    expect(store.access, isNull);
    expect(store.refresh, isNull);
    expect(expired, isTrue);
  });

  test('refresh failure clears session without another request', () async {
    auth.fails = true;
    final adapter = SequenceAdapter([401]);
    dio.httpClientAdapter = adapter;
    await expectLater(
      dio.get<dynamic>('/protected'),
      throwsA(isA<DioException>()),
    );
    expect(adapter.authorization.length, 1);
    expect(store.access, isNull);
    expect(expired, isTrue);
  });

  test('missing refresh token clears remaining access token', () async {
    store.refresh = null;
    dio.httpClientAdapter = SequenceAdapter([401]);
    await expectLater(
      dio.get<dynamic>('/protected'),
      throwsA(isA<DioException>()),
    );
    expect(auth.refreshes, 0);
    expect(store.access, isNull);
    expect(expired, isTrue);
  });

  test(
    'network failure during retry does not invalidate renewed session',
    () async {
      dio.httpClientAdapter = SequenceAdapter([401, 503]);
      await expectLater(
        dio.get<dynamic>('/protected'),
        throwsA(isA<DioException>()),
      );
      expect(auth.refreshes, 1);
      expect(store.access, 'renewed-access-token');
      expect(expired, isFalse);
    },
  );
}
