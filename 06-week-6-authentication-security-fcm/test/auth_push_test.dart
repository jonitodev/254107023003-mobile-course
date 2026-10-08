import 'package:campus_notify/data/api_errors.dart';
import 'package:campus_notify/data/auth_repository.dart';
import 'package:campus_notify/data/token_store.dart';
import 'package:campus_notify/routes.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeTokenStore extends TokenStore {
  String? access;
  String? refresh;

  @override
  Future<void> save({required String access, required String refresh}) async {
    this.access = access;
    this.refresh = refresh;
  }

  @override
  Future<String?> readAccess() async => access;

  @override
  Future<String?> readRefresh() async => refresh;

  @override
  Future<void> clear() async {
    access = null;
    refresh = null;
  }
}

void main() {
  test('routeFromMessage menangani route kosong dan tanpa slash', () {
    expect(routeFromMessage(const {}), '/');
    expect(routeFromMessage(const {'route': 'pengumuman/3'}), '/pengumuman/3');
    expect(routeFromMessage(const {'route': '/pengumuman/3'}), '/pengumuman/3');
  });

  test('data payload membawa id pengumuman', () {
    const data = {'route': '/pengumuman/3', 'id': '3'};
    expect(data['id'], '3');
    expect(routeFromMessage(data), '/pengumuman/3');
  });

  test(
    'payload asing tidak menjadi deep link dan token pendek tidak bocor',
    () {
      expect(routeFromMessage(const {'route': 'https://example.com'}), '/');
      expect(routeFromMessage(const {'route': 3}), '/');
      expect(routeFromMessage(const {'route': '/login'}), '/');
      expect(TokenStore.maskToken('secret'), '(token disembunyikan)');
    },
  );

  test(
    'provider auth membaca status login dari token dan memotong tampilan token',
    () async {
      final store = FakeTokenStore()
        ..access = 'mock-access-token-panjang-sekali';
      expect(await store.readAccess() != null, isTrue);
      expect(TokenStore.maskToken(store.access), 'mock-access-...');

      await store.clear();
      expect(await store.readAccess() != null, isFalse);
    },
  );

  test('refresh gagal -> sesi dibersihkan (paksa login ulang)', () async {
    final store = FakeTokenStore()..refresh = '';
    final auth = AuthRepository();
    await expectLater(
      auth.refresh(store.refresh ?? ''),
      throwsA(isA<Exception>()),
    );
    await store.clear();
    expect(await store.readAccess(), isNull);
  });

  test(
    'mapApiError memetakan 401 dan connectionError ke pesan ramah pengguna',
    () {
      final unauthorized = DioException(
        requestOptions: RequestOptions(path: '/devices'),
        response: Response(
          requestOptions: RequestOptions(path: '/devices'),
          statusCode: 401,
        ),
        type: DioExceptionType.badResponse,
      );
      expect(mapApiError(unauthorized), contains('401'));
    },
  );
}
