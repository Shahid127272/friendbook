import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class NotesService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // -----------------------------
  // 🟢 Add Note
  // -----------------------------
  Future<void> addNote(String title, String content) async {
    await _db
        .collection('notes')
        .doc(uid)
        .collection('user_notes')
        .add({
      'title': title,
      'content': content,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // -----------------------------
  // 🟢 Get Notes (Real-time)
  // -----------------------------
  Stream<QuerySnapshot> getNotes() {
    return _db
        .collection('notes')
        .doc(uid)
        .collection('user_notes')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  // -----------------------------
  // 🟢 Update Note
  // -----------------------------
  Future<void> updateNote(
      String noteId, String newTitle, String newContent) async {
    await _db
        .collection('notes')
        .doc(uid)
        .collection('user_notes')
        .doc(noteId)
        .update({
      'title': newTitle,
      'content': newContent,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // -----------------------------
  // 🟢 Delete Note
  // -----------------------------
  Future<void> deleteNote(String noteId) async {
    await _db
        .collection('notes')
        .doc(uid)
        .collection('user_notes')
        .doc(noteId)
        .delete();
  }
}
