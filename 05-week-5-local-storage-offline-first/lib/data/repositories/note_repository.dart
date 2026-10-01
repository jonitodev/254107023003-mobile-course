import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';

import '../local/db.dart';
import '../local/note.dart';

class NoteRepository {
  NoteRepository({Future<Database> Function()? openDb})
    : _openDb = openDb ?? openNotesDb;

  final Future<Database> Function() _openDb;

  Future<List<Note>> fetchNotes() async {
    final db = await _openDb();
    final rows = await db.query('notes', orderBy: 'updated_at DESC');
    return rows.map(Note.fromMap).toList();
  }

  Future<Note?> fetchNoteById(int id) async {
    final db = await _openDb();
    final rows = await db.query(
      'notes',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return Note.fromMap(rows.first);
  }

  Future<Note> addNote({required String title, String body = ''}) async {
    final db = await _openDb();
    final note = Note(
      title: title,
      body: body,
      updatedAt: DateTime.now(),
      dirty: true,
    );
    final id = await db.insert('notes', note.toMap());
    return Note(
      id: id,
      title: note.title,
      body: note.body,
      updatedAt: note.updatedAt,
      dirty: true,
    );
  }

  Future<void> deleteNote(int id) async {
    final db = await _openDb();
    await db.delete('notes', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateNote(
    Note note, {
    required String title,
    required String body,
  }) async {
    final db = await _openDb();
    await db.update(
      'notes',
      {
        'title': title,
        'body': body,
        'updated_at': DateTime.now().toIso8601String(),
        'dirty': 1,
      },
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  Future<int> countDirty() async {
    final db = await _openDb();
    final rows = await db.rawQuery(
      'SELECT COUNT(*) AS c FROM notes WHERE dirty = 1',
    );
    return ((rows.first['c'] as num?)?.toInt() ?? 0);
  }

  /// Hanya versi yang masuk snapshot sync yang boleh dibersihkan.
  /// Edit baru selama proses sync tetap dirty dan dikirim pada percobaan berikut.
  Future<int> markSnapshotSynced(List<Note> snapshot) async {
    final db = await _openDb();
    return db.transaction((txn) async {
      var count = 0;
      for (final note in snapshot) {
        count += await txn.update(
          'notes',
          {'dirty': 0},
          where: 'id = ? AND updated_at = ? AND dirty = 1',
          whereArgs: [note.id, note.updatedAt.toIso8601String()],
        );
      }
      return count;
    });
  }
}

final noteRepositoryProvider = Provider<NoteRepository>(
  (ref) => NoteRepository(),
);

final notesProvider = FutureProvider<List<Note>>(
  (ref) => ref.watch(noteRepositoryProvider).fetchNotes(),
  retry: (retryCount, error) => null,
);

final dirtyCountProvider = FutureProvider<int>(
  (ref) => ref.watch(noteRepositoryProvider).countDirty(),
  retry: (retryCount, error) => null,
);

class ForceOfflineNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void setOffline(bool value) => state = value;
}

final forceOfflineProvider = NotifierProvider<ForceOfflineNotifier, bool>(
  ForceOfflineNotifier.new,
);
