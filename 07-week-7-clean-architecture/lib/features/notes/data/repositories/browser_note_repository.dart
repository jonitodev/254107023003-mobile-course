import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/failures.dart';
import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../models/note_model.dart';

/// Browser persistence adapter for the same domain contract used by SQLite.
class BrowserNoteRepository implements NoteRepository {
  static const storageKey = 'clean_notes_v1';

  Future<List<Note>> _read(SharedPreferences prefs) async {
    final serialized = prefs.getString(storageKey);
    if (serialized == null) return [];
    return (jsonDecode(serialized) as List<dynamic>)
        .map(
          (row) =>
              NoteModel.fromMap(Map<String, Object?>.from(row as Map))
                  .toEntity(),
        )
        .toList();
  }

  @override
  Future<({List<Note> notes, Failure? failure})> fetchNotes() async {
    try {
      final notes = await _read(await SharedPreferences.getInstance());
      notes.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      return (notes: notes, failure: null);
    } catch (_) {
      return (
        notes: <Note>[],
        failure: const LocalFailure('Gagal membaca penyimpanan browser.'),
      );
    }
  }

  @override
  Future<({Note? note, Failure? failure})> addNote({
    required String title,
    String body = '',
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final notes = await _read(prefs);
      final nextId =
          notes.fold<int>(0, (max, n) => (n.id ?? 0) > max ? n.id! : max) + 1;
      final created = Note(
        id: nextId,
        title: title,
        body: body,
        updatedAt: DateTime.now(),
        dirty: true,
      );
      final rows = [...notes, created]
          .map(
            (note) => NoteModel(
              id: note.id,
              title: note.title,
              body: note.body,
              updatedAt: note.updatedAt,
              dirty: note.dirty,
            ).toMap(),
          )
          .toList();
      if (!await prefs.setString(storageKey, jsonEncode(rows))) {
        throw StateError('Storage rejected write');
      }
      return (note: created, failure: null);
    } catch (_) {
      return (
        note: null,
        failure: const LocalFailure('Gagal menyimpan catatan di browser.'),
      );
    }
  }
}
