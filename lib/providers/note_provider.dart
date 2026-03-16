import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/note_model.dart';

class NoteProvider with ChangeNotifier {
  Database? _database;
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  Future<void> initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'efetiktok.db');

    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, content TEXT, date TEXT)',
        );
      },
    );
    await fetchNotes();
  }

  Future<void> fetchNotes() async {
    if (_database == null) await initDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query('notes');
    _notes = List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        content: maps[i]['content'],
        date: maps[i]['date'],
      );
    });
    notifyListeners();
  }

  Future<void> addNote(Note note) async {
    if (_database == null) await initDatabase();
    await _database!.insert('notes', note.toMap());
    await fetchNotes();
  }

  Future<void> updateNote(Note note) async {
    if (_database == null) await initDatabase();
    await _database!.update(
      'notes',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
    await fetchNotes();
  }

  Future<void> deleteNote(int id) async {
    if (_database == null) await initDatabase();
    await _database!.delete('notes', where: 'id = ?', whereArgs: [id]);
    await fetchNotes();
  }
}