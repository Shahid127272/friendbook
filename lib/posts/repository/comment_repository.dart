import 'package:friendbook/posts/models/comment_model.dart';
import 'package:friendbook/services/post_service.dart';

class CommentRepository {
  final PostService _postService = PostService();

  /// --------------------------------------------------
  /// Get all comments of a specific post
  /// --------------------------------------------------
  Future<List<CommentModel>> getComments(String postId) async {
    try {
      final data = await _postService.getComments(postId);

      // JSON → List<CommentModel>
      return data
          .map<CommentModel>((json) => CommentModel.fromJson(json))
          .toList();
    } catch (e) {
      print("REPOSITORY GET COMMENTS ERROR: $e");
      rethrow;
    }
  }

  /// --------------------------------------------------
  /// Add a new comment
  /// --------------------------------------------------
  Future<CommentModel> addComment({
    required String postId,
    required String userId,
    required String text,
  }) async {
    try {
      final data = await _postService.addComment(
        postId: postId,
        userId: userId,
        text: text,
      );

      // JSON → CommentModel
      return CommentModel.fromJson(data);
    } catch (e) {
      print("REPOSITORY ADD COMMENT ERROR: $e");
      rethrow;
    }
  }
}
