import 'package:dio/dio.dart';

import 'auth_repository.dart';
import 'token_store.dart';

Dio buildApiClient(
  TokenStore store,
  AuthRepository auth, {
  void Function()? onSessionExpired,
}) {
  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://example-campus-api.test',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final access = await store.readAccess();
        if (access != null) {
          options.headers['Authorization'] = 'Bearer $access';
        }
        handler.next(options);
      },
      onError: (e, handler) async {
        if (e.response?.statusCode == 401) {
          if (e.requestOptions.extra['authRetried'] == true) {
            await store.clear();
            onSessionExpired?.call();
            return handler.next(e);
          }
          final refresh = await store.readRefresh();
          if (refresh == null || refresh.isEmpty) {
            await store.clear();
            onSessionExpired?.call();
            return handler.next(e);
          }
          try {
            final renewed = await auth.refresh(refresh);
            await store.save(access: renewed, refresh: refresh);
          } catch (_) {
            await store.clear();
            onSessionExpired?.call();
            return handler.next(e);
          }
          try {
            final retry = await dio.fetch<dynamic>(
              e.requestOptions..extra['authRetried'] = true,
            );
            return handler.resolve(retry);
          } on DioException catch (retryError) {
            return handler.next(retryError);
          }
        }
        handler.next(e);
      },
    ),
  );
  return dio;
}
