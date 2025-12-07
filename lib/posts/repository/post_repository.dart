import 'package:friendbook/services/post_service.dart';
import 'package:friendbook/posts/models/post_model.dart';

class PostRepository {
  final PostService _postService = PostService();

  /// -----------------------------
  /// 1) Fetch All Posts
  /// -----------------------------
  Future<List<PostModel>> getAllPosts() async {
    try {
      final data = await _postService.getAllPosts();

      // JSON → List<PostModel>
      return data.map<PostModel>((json) => PostModel.fromJson(json)).toList();
    } catch (e) {
      print("REPOSITORY GET ALL POSTS ERROR: $e");
      rethrow;
    }
  }

  /// -----------------------------
  /// 2) Create New Post
  /// -----------------------------
  Future<PostModel> createPost({
    required String userId,
    required String content,
    String? imageUrl,
  }) async {
    try {
      final data = await _postService.createPost(
        userId: userId,
        content: content,
        imageUrl: imageUrl,
      );

      return PostModel.fromJson(data);
    } catch (e) {
      print("REPOSITORY CREATE POST ERROR: $e");
      rethrow;
    }
  }

  /// -----------------------------
  /// 3) Fetch Post by ID
  /// -----------------------------
  Future<PostModel> getPostById(String id) async {
    try {
      final data = await _postService.getPostById(id);

      return PostModel.fromJson(data);
    } catch (e) {
      print("REPOSITORY GET POST BY ID ERROR: $e");
      rethrow;
    }
  }

  // ===========================================================
  // 4) TOGGLE LIKE  (NEW)
  // ===========================================================

  Future<PostModel> toggleLike({
    required String postId,
    required String userId,
    required bool isLiked,
  }) async {
    try {
      Map<String, dynamic> data;

      if (isLiked) {
        // Pehle se liked hai → UNLIKE call karo
        data = await _postService.unlikePost(postId, userId);
      } else {
        // Like nahi kiya hua → LIKE call karo
        data = await _postService.likePost(postId, userId);
      }

      // Updated post JSON → Model
      return PostModel.fromJson(data);

    } catch (e) {
      print("REPOSITORY TOGGLE LIKE ERROR: $e");
      rethrow;
    }
  }
}
