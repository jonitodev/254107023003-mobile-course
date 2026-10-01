import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/note.dart';
import '../data/repositories/note_repository.dart';
import '../widgets/note_editor.dart';

final noteByIdProvider = FutureProvider.autoDispose.family<Note?, int>(
  (ref, id) => ref.watch(noteRepositoryProvider).fetchNoteById(id),
  retry: (retryCount, error) => null,
);

class NoteDetailPage extends ConsumerWidget {
  const NoteDetailPage({required this.id, super.key});

  final int id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final noteAsync = ref.watch(noteByIdProvider(id));

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Catatan #$id'),
        actions: [
          if (noteAsync.value case final note?)
            IconButton(
              icon: const Icon(Icons.edit),
              tooltip: 'Edit catatan',
              onPressed: () => showDialog<void>(
                context: context,
                builder: (_) => NoteEditor(note: note),
              ),
            ),
        ],
      ),
      body: noteAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat: $err')),
        data: (note) {
          if (note == null) {
            return const Center(child: Text('Catatan tidak ditemukan.'));
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    note.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Diperbarui: ${note.updatedAt.toIso8601String()} · '
                    'Status: ${note.dirty ? "Belum tersinkron (dirty=1)" : "Tersinkron (dirty=0)"}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const Divider(height: 24),
                  Text(note.body.isEmpty ? '(Tanpa isi)' : note.body),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
