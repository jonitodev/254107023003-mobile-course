import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week4_api/data/models/comment.dart';
import 'package:week4_api/data/models/post.dart';
import 'package:week4_api/data/providers.dart';
import 'package:week4_api/data/paged_posts.dart';
import 'package:week4_api/data/repositories/post_repository.dart';

class FakePostRepository extends PostRepository {
  FakePostRepository({this.items, this.throwError = false}) : super(Dio());
  final List<Post>? items;
  final bool throwError;

  @override
  Future<List<Post>> fetchPosts() async {
    if (throwError) {
      throw DioException(
        requestOptions: RequestOptions(path: '/posts'),
        type: DioExceptionType.connectionError,
      );
    }
    return items ?? const [];
  }

  @override
  Future<List<Post>> fetchPostsPage({required int page, int limit = 10}) async {
    return fetchPosts();
  }
}

class ControlledPagedRepository extends PostRepository {
  ControlledPagedRepository() : super(Dio());
  final requests = <int>[];
  Completer<List<Post>> response = Completer<List<Post>>();

  @override
  Future<List<Post>> fetchPostsPage({required int page, int limit = 10}) {
    requests.add(page);
    return response.future;
  }
}

void main() {
  test('fromJson aman terhadap field yang hilang', () {
    final post = Post.fromJson({'id': 7});
    expect(post.id, 7);
    expect(post.title, '');
    expect(post.userId, 0);
  });

  test('Comment.fromJson aman terhadap field yang hilang dan tipe double', () {
    final comment = Comment.fromJson({'postId': 3.0, 'name': null});
    expect(comment.postId, 3);
    expect(comment.id, 0);
    expect(comment.name, '');
    expect(comment.email, '');
    expect(comment.body, '');
  });

  test('friendlyErrorMessage untuk connection error, timeout, dan 404', () {
    final connErr = DioException(
      requestOptions: RequestOptions(path: '/posts'),
      type: DioExceptionType.connectionError,
    );
    expect(friendlyErrorMessage(connErr), contains('terhubung'));

    final timeoutErr = DioException(
      requestOptions: RequestOptions(path: '/posts'),
      type: DioExceptionType.receiveTimeout,
    );
    expect(friendlyErrorMessage(timeoutErr), contains('timeout'));

    final notFoundErr = DioException(
      requestOptions: RequestOptions(path: '/posts/999'),
      response: Response(
        requestOptions: RequestOptions(path: '/posts/999'),
        statusCode: 404,
      ),
      type: DioExceptionType.badResponse,
    );
    expect(friendlyErrorMessage(notFoundErr), contains('404'));
  });

  test('provider sukses dengan repository palsu', () async {
    final container = ProviderContainer(
      overrides: [
        postRepositoryProvider.overrideWithValue(
          FakePostRepository(
            items: const [Post(userId: 1, id: 1, title: 'Tes', body: 'Isi')],
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    final posts = await readPostsOnce(container);
    expect(posts.length, 1);
    expect(posts.first.title, 'Tes');
  });

  test('provider error dengan repository palsu', () async {
    final container = ProviderContainer(
      overrides: [
        postRepositoryProvider.overrideWithValue(
          FakePostRepository(throwError: true),
        ),
      ],
    );
    addTearDown(container.dispose);
    final err = await readPostsErrorOnce(container);
    expect(err, isA<DioException>());
    expect(friendlyErrorMessage(err!), contains('terhubung'));
  });

  test(
    'pagination menahan request ganda saat halaman pertama dimuat',
    () async {
      final repo = ControlledPagedRepository();
      final container = ProviderContainer(
        overrides: [postRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);
      final notifier = container.read(pagedPostsProvider.notifier);
      await Future<void>.delayed(Duration.zero);
      await notifier.loadFirstPage();
      await notifier.loadNextPage();
      expect(repo.requests, [1]);
      repo.response.complete(const []);
      await Future<void>.delayed(Duration.zero);
      expect(container.read(pagedPostsProvider).hasMore, isFalse);
      expect(container.read(pagedPostsProvider).isLoadingMore, isFalse);
    },
  );

  test(
    'pagination mempertahankan data dan bisa retry halaman yang gagal',
    () async {
      final repo = ControlledPagedRepository();
      final container = ProviderContainer(
        overrides: [postRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);
      final notifier = container.read(pagedPostsProvider.notifier);
      await Future<void>.delayed(Duration.zero);
      repo.response.complete(
        List.generate(
          10,
          (i) => Post(userId: 1, id: i + 1, title: 'Post $i', body: ''),
        ),
      );
      await Future<void>.delayed(Duration.zero);
      repo.response = Completer<List<Post>>();
      final next = notifier.loadNextPage();
      repo.response.completeError(Exception('offline'));
      await next;
      expect(container.read(pagedPostsProvider).items.length, 10);
      expect(container.read(pagedPostsProvider).page, 1);
      expect(container.read(pagedPostsProvider).error, isNotNull);
      repo.response = Completer<List<Post>>();
      final retry = notifier.loadNextPage();
      repo.response.complete(const [
        Post(userId: 1, id: 11, title: 'Next', body: ''),
      ]);
      await retry;
      expect(repo.requests, [1, 2, 2]);
      expect(container.read(pagedPostsProvider).items.length, 11);
      expect(container.read(pagedPostsProvider).hasMore, isFalse);
    },
  );
}
