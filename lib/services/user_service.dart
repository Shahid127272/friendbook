import 'package:dio/dio.dart';

class UserService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "https://your-backend-url.com/api",  // TODO: Change to your backend URL
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  /// ---------------------------------------------------------
  /// GET USER BY ID
  /// ---------------------------------------------------------
  Future<Map<String, dynamic>> getUser(String userId) async {
    try {
      final response = await _dio.get("/users/$userId");

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to load user");
      }
    } catch (e) {
      print("GET USER ERROR: $e");
      rethrow;
    }
  }

  /// ---------------------------------------------------------
  /// UPDATE USER DATA
  /// ---------------------------------------------------------
  Future<Map<String, dynamic>> updateUser({
    required String userId,
    String? name,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      final response = await _dio.put(
        "/users/$userId",
        data: {
          "name": name,
          "bio": bio,
          "profileImageUrl": profileImageUrl,
        },
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to update user");
      }
    } catch (e) {
      print("UPDATE USER ERROR: $e");
      rethrow;
    }
  }
}
