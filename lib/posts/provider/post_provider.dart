import 'package:flutter/material.dart';
import 'package:friendbook/posts/models/post_model.dart';
import 'package:friendbook/posts/repository/post_repository.dart';

class PostProvider with ChangeNotifier {
  final PostRepository _postRepository = PostRepository();

  /// -----------------------------
  /// Provider State Variables
  /// -----------------------------
  List<PostModel> _posts = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<PostModel> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// -----------------------------
  /// Load All Posts
  /// -----------------------------
  Future<void> fetchPosts() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _posts = await _postRepository.getAllPosts();

    } catch (e) {
      _errorMessage = "Failed to load posts";
      print("PROVIDER FETCH POSTS ERROR: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// -----------------------------
  /// Create Post
  /// -----------------------------
  Future<void> createPost({
    required String userId,
    required String content,
    String? imageUrl,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final newPost = await _postRepository.createPost(
        userId: userId,
        content: content,
        imageUrl: imageUrl,
      );

      // Insert at top
      _posts.insert(0, newPost);
      notifyListeners();

    } catch (e) {
      _errorMessage = "Failed to create post";
      print("PROVIDER CREATE POST ERROR: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// -----------------------------
  /// Get Single Post
  /// -----------------------------
  Future<PostModel?> getPostById(String id) async {
    try {
      return await _postRepository.getPostById(id);
    } catch (e) {
      print("PROVIDER GET POST BY ID ERROR: $e");
      return null;
    }
  }

  // ===========================================================
  //  LIKE SYSTEM — Toggle Like
  // ===========================================================
  Future<void> toggleLike(String postId, String userId) async {
    try {
      // Step 1: Find the post from list
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index == -1) return;

      final post = _posts[index];

      // Step 2: OLD like state store
      final oldIsLiked = post.isLikedByMe;

      // Step 3: Instant optimistic UI
      if (post.isLikedByMe) {
        post.likes.remove(userId);
      } else {
        post.likes.add(userId);
      }

      post.isLikedByMe = !post.isLikedByMe;
      notifyListeners();

      // Step 4: Backend update
      final updatedPost = await _postRepository.toggleLike(
        postId: postId,
        userId: userId,
        isLiked: oldIsLiked,
      );

      // Step 5: Replace with updated data
      _posts[index] = updatedPost;
      notifyListeners();

    } catch (e) {
      print("PROVIDER LIKE ERROR: $e");
    }
  }
}
