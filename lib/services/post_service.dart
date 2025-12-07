import 'package:dio/dio.dart';

class PostService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://your-backend-url.com/api",   // ← isay baad me FriendBook backend URL se replace karenge
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// -----------------------------
  /// 1) Fetch all posts
  /// -----------------------------
  Future<List<dynamic>> getAllPosts() async {
    try {
      final response = await _dio.get("/posts");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load posts");
      }
    } catch (e) {
      print("GET POSTS ERROR: $e");
      rethrow;
    }
  }

  /// -----------------------------
  /// 2) Create a new post
  /// -----------------------------
  Future<Map<String, dynamic>> createPost({
    required String userId,
    required String content,
    String? imageUrl,
  }) async {
    try {
      final response = await _dio.post(
        "/posts",
        data: {
          "userId": userId,
          "content": content,
          "imageUrl": imageUrl,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response.data;
      } else {
        throw Exception("Failed to create post");
      }
    } catch (e) {
      print("CREATE POST ERROR: $e");
      rethrow;
    }
  }

  /// -----------------------------
  /// 3) Get single post by ID
  /// -----------------------------
  Future<Map<String, dynamic>> getPostById(String id) async {
    try {
      final response = await _dio.get("/posts/$id");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load post");
      }
    } catch (e) {
      print("GET POST BY ID ERROR: $e");
      rethrow;
    }
  }

  // =============================================
  // 4) LIKE SYSTEM (NEW)
  // =============================================

  /// LIKE a post
  Future<Map<String, dynamic>> likePost(String postId, String userId) async {
    try {
      final response = await _dio.post(
        "/posts/$postId/like",
        data: {"userId": userId},
      );

      return response.data;
    } catch (e) {
      print("LIKE POST ERROR: $e");
      rethrow;
    }
  }

  /// UNLIKE a post
  Future<Map<String, dynamic>> unlikePost(String postId, String userId) async {
    try {
      final response = await _dio.post(
        "/posts/$postId/unlike",
        data: {"userId": userId},
      );

      return response.data;
    } catch (e) {
      print("UNLIKE POST ERROR: $e");
      rethrow;
    }
  }
}
