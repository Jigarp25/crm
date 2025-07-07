import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:crm/widgets/detailcontainer.dart';
import 'package:crm/utils/ui_utils.dart';
import 'controller.dart';

class Note extends StatefulWidget {
  final String parentCollection;
  final String parentId;
  final String createdBy;

  const Note({
    super.key,
    required this.parentCollection,
    required this.parentId,
    required this.createdBy,
  });

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  late NoteController controller;

  @override
  void initState() {
    super.initState();
    controller = NoteController(
      parentCollection: widget.parentCollection,
      parentId: widget.parentId,
    );
  }

  @override
  void dispose() {
    controller.disposeNoteFields();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: controller,
      child: Consumer<NoteController>(
        builder: (context, controller, _) {
          return DetailContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Notes:', style: TextStyle(fontSize: 18)),
                vSpace(8),
                TextField(
                  controller: controller.txtNote,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: 'Write a note...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                vSpace(8),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      final noteText = controller.txtNote.text.trim();
                      if (noteText.isNotEmpty) {
                        await controller.addNote(noteText, widget.createdBy);
                      }
                    },
                    child: const Text('Save Note'),
                  ),
                ),
                vSpace(16),
                if (controller.notes.isNotEmpty)
                  const Text('Previous Notes:', style: TextStyle(fontSize: 18)),
                ...controller.notes.asMap().entries.map((entry) {
                  int index = entry.key;
                  final note = controller.notes[index];
                  final isOwner = note['createdBy'] == widget.createdBy;

                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller.noteEdit[index],
                            maxLines: null,
                            readOnly: !isOwner,
                            decoration: InputDecoration(
                              labelText:
                              'Note ${controller.notes.length - index}',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onChanged: (value) {
                              if (isOwner) {
                                controller.updateNote(index, value);
                              }
                            },
                          ),
                        ),
                        hSpace(8),
                        if (isOwner)
                          IconButton(
                            onPressed: () => controller.deleteNote(index),
                            icon: const Icon(Icons.delete_outline_outlined),
                          ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          );
        },
      ),
    );
  }
}
