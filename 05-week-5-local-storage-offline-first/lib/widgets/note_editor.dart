import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/local/note.dart';
import '../data/repositories/note_repository.dart';
import '../pages/note_detail_page.dart';

/// Controller dialog mengikuti lifecycle widget, termasuk animasi penutupan.
class NoteEditor extends ConsumerStatefulWidget {
  const NoteEditor({this.note, super.key});

  final Note? note;

  @override
  ConsumerState<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends ConsumerState<NoteEditor> {
  late final _title = TextEditingController(text: widget.note?.title);
  late final _body = TextEditingController(text: widget.note?.body);
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_title.text.trim().isEmpty) {
      setState(() => _error = 'Judul wajib diisi.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final repo = ref.read(noteRepositoryProvider);
      if (widget.note case final note?) {
        await repo.updateNote(
          note,
          title: _title.text.trim(),
          body: _body.text.trim(),
        );
        ref.invalidate(noteByIdProvider(note.id!));
      } else {
        await repo.addNote(title: _title.text.trim(), body: _body.text.trim());
      }
      ref.invalidate(notesProvider);
      ref.invalidate(dirtyCountProvider);
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        setState(() {
          _saving = false;
          _error = 'Gagal menyimpan: $error';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(widget.note == null ? 'Catatan Baru' : 'Edit Catatan'),
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _title,
            decoration: const InputDecoration(labelText: 'Judul'),
          ),
          TextField(
            controller: _body,
            decoration: const InputDecoration(labelText: 'Isi catatan'),
            minLines: 2,
            maxLines: 5,
          ),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: _saving ? null : () => Navigator.pop(context),
        child: const Text('Batal'),
      ),
      FilledButton(
        onPressed: _saving ? null : _save,
        child: Text(_saving ? 'Menyimpan…' : 'Simpan'),
      ),
    ],
  );
}
