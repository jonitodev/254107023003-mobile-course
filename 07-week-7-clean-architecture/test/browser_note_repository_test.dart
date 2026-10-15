import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:week7_clean_architecture/core/failures.dart';
import 'package:week7_clean_architecture/features/notes/data/repositories/browser_note_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('saved note survives a new repository instance', () async {
    final first = BrowserNoteRepository();
    await first.addNote(title: 'Catatan tersimpan', body: 'Offline browser');
    await first.addNote(title: 'Catatan kedua');
    final result = await BrowserNoteRepository().fetchNotes();
    expect(result.failure, isNull);
    expect(result.notes.map((note) => note.id).toSet(), {1, 2});
    expect(result.notes.any((note) => note.body == 'Offline browser'), isTrue);
  });

  test(
    'corrupted browser data returns failure instead of being overwritten',
    () async {
      SharedPreferences.setMockInitialValues({
        BrowserNoteRepository.storageKey: 'broken-json',
      });
      final repository = BrowserNoteRepository();
      expect((await repository.fetchNotes()).failure, isA<LocalFailure>());
      expect(
        (await repository.addNote(title: 'New')).failure,
        isA<LocalFailure>(),
      );
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString(BrowserNoteRepository.storageKey), 'broken-json');
    },
  );
}
