import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/note_repository.dart';
import '../data/sync.dart';

class CachedPostsPage extends ConsumerWidget {
  const CachedPostsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(cachedPostsProvider);
    final offline = ref.watch(forceOfflineProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bacaan tersimpan'),
        actions: [
          IconButton(
            tooltip: 'Muat ulang cache',
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(cachedPostsProvider),
          ),
        ],
      ),
      body: Column(
        children: [
          ListTile(
            leading: Icon(offline ? Icons.airplanemode_active : Icons.storage),
            title: Text(
              offline
                  ? 'Offline · membaca SQLite'
                  : 'Cache lokal tampil lebih dahulu',
            ),
            subtitle: const Text(
              'Saat online, hingga 5 post JSONPlaceholder diperbarui ke cache.',
            ),
          ),
          Expanded(
            child: posts.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Gagal membaca cache: $e')),
              data: (items) => items.isEmpty
                  ? const Center(
                      child: Text(
                        'Cache kosong. Buka halaman ini saat online terlebih dahulu.',
                      ),
                    )
                  : ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (_, index) {
                        final item = items[index];
                        return ListTile(
                          leading: CircleAvatar(child: Text('${item.id}')),
                          title: Text(item.title),
                          subtitle: Text(
                            'Disimpan: ${item.cachedAt.toLocal()}',
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
