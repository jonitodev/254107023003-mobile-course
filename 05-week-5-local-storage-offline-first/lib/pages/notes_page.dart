import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../data/repositories/note_repository.dart';
import '../data/sync.dart';
import '../widgets/note_tile.dart';
import '../widgets/note_editor.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);
    final dirtyAsync = ref.watch(dirtyCountProvider);
    final forceOffline = ref.watch(forceOfflineProvider);
    final dirtyCount = dirtyAsync.value ?? 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Notes — TI-3F'),
        actions: [
          Badge(
            isLabelVisible: dirtyCount > 0,
            label: Text('$dirtyCount'),
            child: IconButton(
              icon: const Icon(Icons.sync),
              tooltip: 'Simulasi sinkronisasi ($dirtyCount dirty)',
              onPressed: () async {
                try {
                  final synced = await syncNotes(
                    ref.read(noteRepositoryProvider),
                    isOffline: forceOffline,
                  );
                  ref.invalidate(notesProvider);
                  ref.invalidate(dirtyCountProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Simulasi selesai: $synced catatan ditandai sinkron.',
                        ),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text('$e')));
                  }
                }
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.article_outlined),
            tooltip: 'Bacaan tersimpan',
            onPressed: () => context.push('/cache'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Pengaturan',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: forceOffline
                ? Theme.of(context).colorScheme.tertiaryContainer
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Row(
              children: [
                Icon(
                  forceOffline ? Icons.airplanemode_active : Icons.wifi,
                  size: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    forceOffline
                        ? 'Mode Offline Aktif · Antrean dirty: $dirtyCount'
                        : 'Joni Yoga Kusuma · NIM 254107023003 · TI-3F · Dirty: $dirtyCount',
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: notesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Gagal memuat catatan lokal: $err'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => ref.invalidate(notesProvider),
                      child: const Text('Coba lagi'),
                    ),
                  ],
                ),
              ),
              data: (notes) {
                if (notes.isEmpty) {
                  return const Center(
                    child: Text('Belum ada catatan. Tambah catatan offline!'),
                  );
                }
                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return NoteTile(
                      note: note,
                      onTap: () {
                        if (note.id != null) {
                          context.push('/note/${note.id}');
                        }
                      },
                      onDelete: () async {
                        if (note.id != null) {
                          await ref
                              .read(noteRepositoryProvider)
                              .deleteNote(note.id!);
                          ref.invalidate(notesProvider);
                          ref.invalidate(dirtyCountProvider);
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog<void>(
          context: context,
          builder: (_) => const NoteEditor(),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
