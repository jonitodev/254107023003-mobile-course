import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/post.dart';
import '../data/paged_posts.dart';
import '../data/providers.dart';

class PostDetailPage extends ConsumerWidget {
  const PostDetailPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allPosts = ref.watch(postListProvider).value;
    final pagedPosts = ref.watch(pagedPostsProvider).items;

    Post? cachedPost =
        allPosts?.where((p) => p.id == id).firstOrNull ??
        pagedPosts.where((p) => p.id == id).firstOrNull;

    final commentsAsync = ref.watch(commentsByPostProvider(id));

    return Scaffold(
      appBar: AppBar(title: Text('Post #$id')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (cachedPost != null)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cachedPost.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(cachedPost.body),
                  ],
                ),
              ),
            )
          else
            FutureBuilder<Post>(
              future: ref.read(postRepositoryProvider).fetchPostById(id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Text(friendlyErrorMessage(snapshot.error!));
                }
                final post = snapshot.data!;
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(post.body),
                      ],
                    ),
                  ),
                );
              },
            ),
          const SizedBox(height: 16),
          Text('Komentar', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          commentsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (err, _) => Column(
              children: [
                Text(friendlyErrorMessage(err)),
                TextButton(
                  onPressed: () => ref.invalidate(commentsByPostProvider(id)),
                  child: const Text('Coba lagi'),
                ),
              ],
            ),
            data: (comments) => Column(
              children: [
                for (final c in comments)
                  Card(
                    child: ListTile(
                      title: Text(c.name),
                      subtitle: Text('${c.email}\n${c.body}'),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
