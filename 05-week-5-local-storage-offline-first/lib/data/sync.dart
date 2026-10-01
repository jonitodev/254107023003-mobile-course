import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import 'local/db.dart';
import 'repositories/note_repository.dart';

class CachedPost {
  const CachedPost({
    required this.id,
    required this.title,
    required this.cachedAt,
  });

  final int id;
  final String title;
  final DateTime cachedAt;
}

/// Emit cache segera, kemudian emit ulang setelah refresh selesai.
final cachedPostsProvider = StreamProvider.autoDispose<List<CachedPost>>((
  ref,
) async* {
  final offline = ref.watch(forceOfflineProvider);
  final dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  ref.onDispose(() => dio.close(force: true));
  yield await loadPostsCacheFirst(isOffline: true);
  if (!offline) {
    await _refreshPostsInBackground(await openNotesDb(), dio);
    yield await loadPostsCacheFirst(isOffline: true);
  }
});

/// Simulasi pengakuan server untuk snapshot catatan dirty.
/// Belum mengirim HTTP atau membandingkan versi catatan dengan server nyata.
Future<int> syncNotes(
  NoteRepository repo, {
  bool isOffline = false,
  Duration simulatedLatency = const Duration(milliseconds: 500),
}) async {
  if (isOffline) {
    throw Exception('Mode offline aktif: sinkronisasi ditunda ke antrean.');
  }
  final pending = (await repo.fetchNotes())
      .where((note) => note.dirty)
      .toList();
  if (pending.isEmpty) return 0;

  if (simulatedLatency > Duration.zero) {
    await Future<void>.delayed(simulatedLatency);
  }
  return repo.markSnapshotSynced(pending);
}

/// Cache-first read: baca tabel `cached_posts` segera, lalu perbarui di background.
Future<List<CachedPost>> loadPostsCacheFirst({
  Future<Database> Function() openDb = openNotesDb,
  Dio? dio,
  bool isOffline = false,
}) async {
  final db = await openDb();
  final rows = await db.query('cached_posts', orderBy: 'id ASC');
  final cached = rows.map((row) {
    final decoded = jsonDecode(row['payload'] as String? ?? '{}');
    final map = decoded is Map<String, dynamic>
        ? decoded
        : const <String, dynamic>{};
    return CachedPost(
      id: (row['id'] as num?)?.toInt() ?? 0,
      title: map['title'] as String? ?? '',
      cachedAt:
          DateTime.tryParse(row['cached_at'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0),
    );
  }).toList();

  if (!isOffline && dio != null) {
    _refreshPostsInBackground(db, dio);
  }

  return cached;
}

Future<void> _refreshPostsInBackground(Database db, Dio dio) async {
  try {
    final res = await dio.get<List<dynamic>>(
      'https://jsonplaceholder.typicode.com/posts',
      queryParameters: {'_limit': 5},
    );
    final now = DateTime.now().toIso8601String();
    final batch = db.batch();
    for (final item
        in (res.data ?? const <dynamic>[]).whereType<Map<String, dynamic>>()) {
      batch.insert('cached_posts', {
        'id': (item['id'] as num?)?.toInt() ?? 0,
        'payload': jsonEncode(item),
        'cached_at': now,
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  } catch (_) {
    // Abaikan kegagalan background refresh agar cache lokal tetap tampil.
  }
}
