import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

Future<Database> openNotesDb() async {
  if (kIsWeb) databaseFactory = databaseFactoryFfiWeb;
  final path = kIsWeb
      ? 'offline_notes.db'
      : p.join(await getDatabasesPath(), 'offline_notes.db');
  return openDatabase(
    path,
    version: 2,
    onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE notes(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          title TEXT NOT NULL,
          body TEXT NOT NULL DEFAULT '',
          updated_at TEXT NOT NULL,
          dirty INTEGER NOT NULL DEFAULT 0
        )
      ''');
      await db.execute('''
        CREATE TABLE cached_posts(
          id INTEGER PRIMARY KEY,
          payload TEXT NOT NULL,
          cached_at TEXT NOT NULL
        )
      ''');
      await _createIndexes(db);
    },
    onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) await _createIndexes(db);
    },
  );
}

Future<void> _createIndexes(Database db) async {
  await db.execute(
    'CREATE INDEX IF NOT EXISTS idx_notes_updated_at ON notes(updated_at DESC)',
  );
  await db.execute(
    'CREATE INDEX IF NOT EXISTS idx_notes_dirty ON notes(dirty)',
  );
}
