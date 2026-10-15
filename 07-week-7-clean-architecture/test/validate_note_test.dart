import 'package:flutter_test/flutter_test.dart';
import 'package:week7_clean_architecture/core/failures.dart';
import 'package:week7_clean_architecture/features/notes/domain/usecases/add_note.dart';

import 'get_notes_test.dart';

void main() {
  test('AddNote menolak judul kosong dengan ValidationFailure', () async {
    final repo = FakeNoteRepository();
    final useCase = AddNote(repo);

    final result = await useCase.call(title: '   ', body: 'Isi');
    expect(result.note, isNull);
    expect(result.failure, isA<ValidationFailure>());
  });

  test('AddNote menyimpan catatan bila judul valid', () async {
    final repo = FakeNoteRepository();
    final useCase = AddNote(repo);

    final result = await useCase.call(
      title: '  Ringkasan Clean Architecture  ',
      body: 'Layer domain murni',
    );
    expect(result.failure, isNull);
    expect(result.note?.title, 'Ringkasan Clean Architecture');
  });
}
