import 'package:flutter/material.dart';
import 'package:friendbook/user/models/user_model.dart';
import 'package:friendbook/user/repository/user_repository.dart';

class UserProvider with ChangeNotifier {
  final UserRepository _userRepository = UserRepository();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// ---------------------------------------------------------
  /// LOAD USER FROM BACKEND
  /// ---------------------------------------------------------
  Future<void> loadUser(String userId) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentUser = await _userRepository.getUser(userId);

    } catch (e) {
      _errorMessage = "Failed to load user";
      print("USER PROVIDER ERROR: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ---------------------------------------------------------
  /// UPDATE USER PROFILE
  /// ---------------------------------------------------------
  Future<void> updateUser({
    required String userId,
    String? name,
    String? bio,
    String? profileImageUrl,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final updatedUser = await _userRepository.updateUser(
        userId: userId,
        name: name,
        bio: bio,
        profileImageUrl: profileImageUrl,
      );

      _currentUser = updatedUser;
      notifyListeners();

    } catch (e) {
      _errorMessage = "Failed to update user";
      print("UPDATE USER PROVIDER ERROR: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
