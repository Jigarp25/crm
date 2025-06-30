import 'package:crm/widgets/detailcontainer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/ui_utils.dart';

class Note extends StatefulWidget {
  final String noteKey;

  const Note({super.key, required this.noteKey});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  final TextEditingController _noteController = TextEditingController();
  List<String> notes = [];
  List<TextEditingController> noteControllers = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  @override
  void dispose() {
    _noteController.dispose();
    for (var controller in noteControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final loadedNotes = prefs.getStringList(widget.noteKey) ?? [];
    setState(() {
      notes = loadedNotes;
      noteControllers = List.generate(
        notes.length,
            (index) => TextEditingController(text: notes[index]),
      );
    });
  }

  Future<void> _saveNotes() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(widget.noteKey, notes);
  }

  Future<void> _addNote(String noteText) async {
    setState(() {
      notes.insert(0, noteText);
      noteControllers.insert(0, TextEditingController(text: noteText));
      _noteController.clear();
    });
    await _saveNotes();
  }

  Future<void> _updateNote(int index, String newValue) async {
    notes[index] = newValue;
    await _saveNotes();
  }

  Future<void> _deleteNote(int index) async {
    setState(() {
      notes.removeAt(index);
      noteControllers.removeAt(index);
    });
    await _saveNotes();
  }

  @override
  Widget build(BuildContext context) {
    return DetailContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Notes:', style: TextStyle(fontSize: 18)),
          vSpace(8),
          TextField(
            controller: _noteController,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: 'Write a note...',
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
          vSpace(8),
          Center(
            child: ElevatedButton(
              onPressed: () async {
                final noteText = _noteController.text.trim();
                if (noteText.isNotEmpty) {
                  await _addNote(noteText);
                }
              },
              child: const Text('Save Note'),
            ),
          ),
          vSpace(16),
          if (notes.isNotEmpty) const Text('Previous Notes:', style: TextStyle(fontSize: 18)),
          ...notes.asMap().entries.map((entry) {
            int index = entry.key;
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextField(
                      controller: noteControllers[index],
                      maxLines: null,
                      decoration: InputDecoration(
                        labelText: 'Note ${notes.length - index}',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onChanged: (value) => _updateNote(index, value),
                    ),
                  ),
                  hSpace(8),
                  IconButton(
                    onPressed: () => _deleteNote(index),
                    icon: const Icon(Icons.delete_outline_outlined),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
