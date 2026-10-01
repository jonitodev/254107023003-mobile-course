import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:week5_offline_notes/data/local/note.dart';
import 'package:week5_offline_notes/data/repositories/note_repository.dart';
import 'package:week5_offline_notes/data/sync.dart';

class FakeNoteRepository extends NoteRepository {
  FakeNoteRepository({this.items = const [], this.throwError = false})
    : super(openDb: () => throw UnimplementedError());

  List<Note> items;
  final bool throwError;

  @override
  Future<List<Note>> fetchNotes() async {
    if (throwError) throw Exception('db locked (simulasi)');
    return items;
  }

  @override
  Future<int> countDirty() => Future.value(items.where((n) => n.dirty).length);

  @override
  Future<int> markSnapshotSynced(List<Note> snapshot) async {
    var count = 0;
    items = [
      for (final n in items)
        if (n.dirty &&
            snapshot.any((s) => s.id == n.id && s.updatedAt == n.updatedAt))
          (() {
            count++;
            return Note(
              id: n.id,
              title: n.title,
              body: n.body,
              updatedAt: n.updatedAt,
              dirty: false,
            );
          })()
        else
          n,
    ];
    return count;
  }
}

void main() {
  test('fromMap aman terhadap field yang hilang', () {
    final note = Note.fromMap({'title': 'Belanja'});
    expect(note.title, 'Belanja');
    expect(note.body, '');
    expect(note.dirty, isFalse);
  });

  test('flag dirty bertahan pada serialisasi', () {
    final note = Note(
      title: 'a',
      updatedAt: DateTime(2026, 9, 18),
      dirty: true,
    );
    final restored = Note.fromMap(note.toMap());
    expect(restored.dirty, isTrue);
  });

  test('provider sukses dengan repository palsu', () async {
    final container = ProviderContainer(
      overrides: [
        noteRepositoryProvider.overrideWithValue(
          FakeNoteRepository(
            items: [Note(title: 'Tes', updatedAt: DateTime.now())],
          ),
        ),
      ],
    );
    addTearDown(container.dispose);
    final notes = await container.read(notesProvider.future);
    expect(notes.length, 1);
    expect(notes.first.title, 'Tes');
  });

  test('provider error dengan repository palsu', () async {
    final container = ProviderContainer(
      overrides: [
        noteRepositoryProvider.overrideWithValue(
          FakeNoteRepository(throwError: true),
        ),
      ],
    );
    addTearDown(container.dispose);
    await expectLater(
      container.read(notesProvider.future),
      throwsA(isA<Exception>()),
    );
  });

  test('syncNotes membersihkan flag dirty ketika online', () async {
    final repo = FakeNoteRepository(
      items: [
        Note(id: 1, title: 'Catatan 1', updatedAt: DateTime.now(), dirty: true),
        Note(
          id: 2,
          title: 'Catatan 2',
          updatedAt: DateTime.now(),
          dirty: false,
        ),
      ],
    );

    expect(await repo.countDirty(), 1);
    final syncedCount = await syncNotes(repo, simulatedLatency: Duration.zero);
    expect(syncedCount, 1);
    expect(await repo.countDirty(), 0);
  });

  test('syncNotes offline mempertahankan catatan dirty', () async {
    final repo = FakeNoteRepository(
      items: [
        Note(id: 1, title: 'Offline', updatedAt: DateTime(2026), dirty: true),
      ],
    );
    await expectLater(syncNotes(repo, isOffline: true), throwsException);
    expect(await repo.countDirty(), 1);
  });

  test('edit baru tidak diakui oleh snapshot sync yang lama', () async {
    final original = Note(
      id: 1,
      title: 'Lama',
      updatedAt: DateTime(2026),
      dirty: true,
    );
    final repo = FakeNoteRepository(items: [original]);
    final syncing = syncNotes(
      repo,
      simulatedLatency: const Duration(milliseconds: 20),
    );
    await Future<void>.delayed(Duration.zero);
    repo.items = [
      Note(id: 1, title: 'Baru', updatedAt: DateTime(2026, 2), dirty: true),
    ];
    expect(await syncing, 0);
    expect(await repo.countDirty(), 1);
  });
}
