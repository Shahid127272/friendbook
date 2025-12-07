package notes;

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'notes_service.dart';

class CreateNotePage extends StatefulWidget {
  final String? noteId;            // null = new note
  final Map<String, dynamic>? existingData;

  const CreateNotePage({
    super.key,
    this.noteId,
    this.existingData,
  });

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  final NotesService _service = NotesService();

  @override
  void initState() {
    super.initState();

    // If editing a note, prefill data
    if (widget.existingData != null) {
      titleController.text = widget.existingData?['title'] ?? '';
      contentController.text = widget.existingData?['content'] ?? '';
    }
  }

  void saveNote() async {
    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty && content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Note is empty")),
      );
      return;
    }

    if (widget.noteId == null) {
      // Create new note
      await _service.addNote(title, content);
    } else {
      // Update existing note
      await _service.updateNote(widget.noteId!, title, content);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.noteId == null ? "New Note" : "Edit Note"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: saveNote,
            icon: const Icon(Icons.save),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 22),
              ),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Expanded(
              child: TextField(
                controller: contentController,
                maxLines: null,
                expands: true,
                decoration: const InputDecoration(
                  hintText: "Write your note...",
                  border: InputBorder.none,
                ),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
