import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/format.dart';
import '../../../../routes.dart';
import '../../domain/entities/note.dart';
import '../providers/notes_providers.dart';

class NotesPage extends ConsumerWidget {
  const NotesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(notesProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Clean Notes — TI-3F')),
      body: state.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => ErrorView(
          message: '$e',
          onRetry: () => ref.invalidate(notesProvider),
        ),
        data: (notes) => notes.isEmpty
            ? const Center(child: Text('Belum ada catatan.'))
            : NotesList(notes),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (idx) {
          if (idx == 1) context.go(AppRoutes.announcements);
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.note_alt_outlined),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.campaign_outlined),
            label: 'Announcements',
          ),
        ],
      ),
    );
  }

  Future<void> _showAddDialog(BuildContext context, WidgetRef ref) async {
    final titleCtrl = TextEditingController();
    final bodyCtrl = TextEditingController();
    var saving = false;
    await showDialog<void>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Tambah Catatan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleCtrl,
                decoration: const InputDecoration(labelText: 'Judul'),
              ),
              TextField(
                controller: bodyCtrl,
                decoration: const InputDecoration(labelText: 'Isi'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: saving ? null : () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: saving
                  ? null
                  : () async {
                      setState(() => saving = true);
                      final res = await ref
                          .read(addNoteProvider)
                          .call(title: titleCtrl.text, body: bodyCtrl.text);
                      if (!context.mounted) return;
                      if (res.failure != null) {
                        setState(() => saving = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(res.failure!.message)),
                        );
                        return;
                      }
                      ref.invalidate(notesProvider);
                      Navigator.pop(context);
                    },
              child: Text(saving ? 'Menyimpan…' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
    titleCtrl.dispose();
    bodyCtrl.dispose();
  }
}

class NotesList extends StatelessWidget {
  const NotesList(this.notes, {super.key});
  final List<Note> notes;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          title: Text(note.title),
          subtitle: Text('${formatShortDate(note.updatedAt)} · ${note.body}'),
          trailing: Icon(
            note.dirty ? Icons.sync_problem : Icons.cloud_done_outlined,
          ),
        );
      },
    );
  }
}

class ErrorView extends StatelessWidget {
  const ErrorView({required this.message, required this.onRetry, super.key});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(message, textAlign: TextAlign.center),
          const SizedBox(height: 12),
          FilledButton(onPressed: onRetry, child: const Text('Coba lagi')),
        ],
      ),
    );
  }
}
