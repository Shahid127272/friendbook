import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:friendbook/posts/models/comment_model.dart';

class CommentRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  /// --------------------------------------------------
  /// FETCH COMMENTS OF A POST
  /// --------------------------------------------------
  Future<List<CommentModel>> fetchComments(String postId) async {
    try {
      final snapshot = await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => CommentModel.fromMap(doc.data()),
      )
          .toList();
    } catch (e) {
      debugPrint("REPOSITORY FETCH COMMENTS ERROR: $e");
      rethrow;
    }
  }

  /// --------------------------------------------------
  /// ADD A NEW COMMENT
  /// --------------------------------------------------
  Future<void> addComment({
    required String postId,
    required String userId,
    required String text,
  }) async {
    try {
      await _firestore
          .collection('posts')
          .doc(postId)
          .collection('comments')
          .add({
        'userId': userId,
        'text': text,
        'createdAt': Timestamp.now(),
      });
    } catch (e) {
      debugPrint("REPOSITORY ADD COMMENT ERROR: $e");
      rethrow;
    }
  }
}
