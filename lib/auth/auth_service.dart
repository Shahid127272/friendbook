import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // -------------------------------
  // 🟢 1. SIGN UP USER
  // -------------------------------
  Future<String?> signUp(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message; // error message
    }
  }

  // -------------------------------
  // 🟢 2. LOGIN USER
  // -------------------------------
  Future<String?> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // -------------------------------
  // 🟢 3. LOGOUT USER
  // -------------------------------
  Future<void> logout() async {
    await _auth.signOut();
  }

  // -------------------------------
  // 🟢 4. FORGOT PASSWORD
  // -------------------------------
  Future<String?> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // -------------------------------
  // 🟢 5. CURRENT USER
  // -------------------------------
  User? get currentUser => _auth.currentUser;

  // -------------------------------
  // 🟢 6. AUTH STATE CHANGES (Auto-login)
  // -------------------------------
  Stream<User?> authStateChanges() => _auth.authStateChanges();
}
