import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/note.dart';

class NotesProvider with ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  NotesProvider() {
    loadNotes();
  }

  Future<void> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? notesJson = prefs.getStringList('notes');
    if (notesJson != null) {
      _notes = notesJson.map((json) => Note.fromJson(json)).toList();
      // Sort by date descending
      _notes.sort((a, b) => b.date.compareTo(a.date));
      notifyListeners();
    }
  }

  Future<void> saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> notesJson = _notes.map((note) => note.toJson()).toList();
    await prefs.setStringList('notes', notesJson);
  }

  void addNote(Note note) {
    _notes.insert(0, note);
    saveNotes();
    notifyListeners();
  }

  void updateNote(Note updatedNote) {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index != -1) {
      _notes[index] = updatedNote;
      _notes.sort((a, b) => b.date.compareTo(a.date)); // Keep sorted
      saveNotes();
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    saveNotes();
    notifyListeners();
  }
}
