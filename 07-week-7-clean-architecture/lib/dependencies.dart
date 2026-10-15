import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'features/announcements/data/repositories/announcement_repository_impl.dart';
import 'features/announcements/domain/repositories/announcement_repository.dart';
import 'features/notes/data/datasources/notes_local_db.dart';
import 'features/notes/data/repositories/browser_note_repository.dart';
import 'features/notes/data/repositories/note_repository_impl.dart';
import 'features/notes/domain/repositories/note_repository.dart';

/// Composition root: only this file chooses concrete data implementations.
final noteRepositoryProvider = Provider<NoteRepository>((ref) {
  return kIsWeb
      ? BrowserNoteRepository()
      : NoteRepositoryImpl(openDb: openNotesDb);
});

final announcementRepositoryProvider = Provider<AnnouncementRepository>((ref) {
  return const AnnouncementRepositoryImpl();
});
