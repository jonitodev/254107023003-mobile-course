import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_repository.dart';
import '../data/api_client.dart';
import '../data/demo_api_adapter.dart';
import '../data/token_store.dart';

final tokenStoreProvider = Provider<TokenStore>((ref) => TokenStore());

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(),
);

final authStateProvider = AsyncNotifierProvider<AuthNotifier, bool>(
  AuthNotifier.new,
  retry: (retryCount, error) => null,
);

class AuthNotifier extends AsyncNotifier<bool> {
  @override
  Future<bool> build() async {
    final token = await ref.watch(tokenStoreProvider).readAccess();
    return token != null && token.isNotEmpty;
  }

  Future<void> login(String email, String password) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final session = await ref
          .read(authRepositoryProvider)
          .login(email: email, password: password);
      await ref
          .read(tokenStoreProvider)
          .save(access: session.access, refresh: session.refresh);
      return true;
    });
  }

  Future<void> rotateAccessToken() async {
    final store = ref.read(tokenStoreProvider);
    final dio = buildApiClient(
      store,
      ref.read(authRepositoryProvider),
      onSessionExpired: () => state = const AsyncData(false),
    )..httpClientAdapter = DemoApiAdapter();
    try {
      await dio.get<dynamic>('/demo/protected');
      ref.invalidate(maskedAccessTokenProvider);
    } finally {
      dio.close();
    }
  }

  Future<void> logout() async {
    await ref.read(tokenStoreProvider).clear();
    state = const AsyncData(false);
  }
}

final maskedAccessTokenProvider = FutureProvider<String>((ref) async {
  ref.watch(authStateProvider);
  final token = await ref.watch(tokenStoreProvider).readAccess();
  return TokenStore.maskToken(token);
});

class TopicSubscriptionNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void toggle() => state = !state;
}

final topicSubscriptionProvider =
    NotifierProvider<TopicSubscriptionNotifier, bool>(
      TopicSubscriptionNotifier.new,
    );
