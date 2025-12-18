import 'package:flutter/material.dart';

import 'package:friendbook/posts/models/comment_model.dart';
import 'package:friendbook/posts/repository/comment_repository.dart';

class CommentProvider extends ChangeNotifier {
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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _comments = await _commentRepository.fetchComments(postId);
    } catch (e) {
      _errorMessage = "Failed to load comments";
      debugPrint("PROVIDER LOAD COMMENTS ERROR: $e");
    }

    _isLoading = false;
    notifyListeners();
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
      await _commentRepository.addComment(
        postId: postId,
        userId: userId,
        text: text,
      );

      // Reload comments to keep data in sync
      await loadComments(postId);
    } catch (e) {
      debugPrint("PROVIDER ADD COMMENT ERROR: $e");
    }
  }
}
