import 'package:flutter/material.dart';
import 'package:friendbook/posts/models/comment_model.dart';
import 'package:friendbook/posts/repository/comment_repository.dart';

class CommentProvider with ChangeNotifier {
  final CommentRepository _commentRepository = CommentRepository();

  List<CommentModel> _comments = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CommentModel> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// -----------------------------------------------------
  /// LOAD COMMENTS OF A POST
  /// -----------------------------------------------------
  Future<void> loadComments(String postId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _comments = await _commentRepository.getComments(postId);
      notifyListeners();
    } catch (e) {
      _errorMessage = "Failed to load comments";
      print("PROVIDER GET COMMENTS ERROR: $e");
      notifyListeners();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// -----------------------------------------------------
  /// ADD NEW COMMENT
  /// -----------------------------------------------------
  Future<void> addComment({
    required String postId,
    required String userId,
    required String text,
  }) async {
    try {
      final newComment = await _commentRepository.addComment(
        postId: postId,
        userId: userId,
        text: text,
      );

      // Add new comment at bottom
      _comments.add(newComment);
      notifyListeners();

    } catch (e) {
      print("PROVIDER ADD COMMENT ERROR: $e");
    }
  }
}
