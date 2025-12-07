import 'package:friendbook/services/user_service.dart';
import 'package:friendbook/user/models/user_model.dart';

class UserRepository {
  final UserService _userService = UserService();

  /// -----------------------------------------------------
  /// GET USER BY ID
  /// -----------------------------------------------------
  Future<UserModel> getUser(String userId) async {
    try {
      final data = await _userService.getUser(userId);

      // JSON → UserModel
      return UserModel.fromJson(data);
    } catch (e) {
      print("REPOSITORY GET USER ERROR: $e");
      rethrow;
    }
  }

  /// -----------------------------------------------------
  /// UPDATE USER
  /// -----------------------------------------------------
  Future<UserModel> updateUser({
    required String userId,
    String? name,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      final data = await _userService.updateUser(
        userId: userId,
        name: name,
        bio: bio,
        profileImageUrl: profileImageUrl,
      );

      return UserModel.fromJson(data);
    } catch (e) {
      print("REPOSITORY UPDATE USER ERROR: $e");
      rethrow;
    }
  }
}
