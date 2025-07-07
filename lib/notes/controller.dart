import 'package:crm/firebase/Apis.dart';
import 'package:crm/firebase/DbConstants.dart';
import 'package:flutter/material.dart';

class NoteController with ChangeNotifier {
  final String parentCollection;
  final String parentId;

  var txtNote = TextEditingController();
  List<Map<String, dynamic>> notes = [];
  List<TextEditingController> noteEdit = [];

  NoteController({required this.parentCollection, required this.parentId}) {
    loadNotes();
  }

  Future<void> loadNotes() async {
    notes = await API.fetchNotes(parentCollection, parentId);
    noteEdit = List.generate(
      notes.length,
          (i) => TextEditingController(text: notes[i]['text']),
    );
    notifyListeners();
  }

  Future<void> addNote(String noteText, String createdBy) async {
    var newNote = {
      'text': noteText,
      Const.keyCreatedAt: DateTime.now(),
      Const.keyCreatedBy: createdBy,
    };

    await API.addNote(parentCollection, parentId, newNote);
    txtNote.clear();
    await loadNotes(); // Refresh UI
  }

  Future<void> updateNote(int index, String newText) async {
    final noteId = notes[index]['id'];
    await API.updateNote(
      parentCollection,
      parentId,
      noteId,
      {'text': newText},
    );
    notes[index]['text'] = newText;
    notifyListeners();
  }

  Future<void> deleteNote(int index) async {
    try {
      var noteId = notes[index]['id'];
      if (noteId == null) throw 'Note Id is null';
      await API.deleteNote(parentCollection, parentId, noteId);

      notes.removeAt(index);
      noteEdit.removeAt(index);
      notifyListeners();
    } catch (e){
      debugPrint('Error deleting note: $e');
    }
  }

  void disposeNoteFields() {
    txtNote.dispose();
    for (var c in noteEdit) {
      c.dispose();
    }
  }
}
