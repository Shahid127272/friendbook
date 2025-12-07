import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FriendService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String uid = FirebaseAuth.instance.currentUser!.uid;

  // -----------------------------
  // 🔵 Add Friend by email
  // -----------------------------
  Future<String?> addFriend(String email) async {
    try {
      // Step 1: find user by email
      final userQuery = await _db
          .collection('users')
          .where('email', isEqualTo: email)
          .get();

      if (userQuery.docs.isEmpty) {
        return "User not found";
      }

      final friendId = userQuery.docs.first.id;

      // Step 2: Save friend under current user
      await _db.collection('friends').doc(uid).set({
        friendId: true,
      }, SetOptions(merge: true));

      return null; // success
    } catch (e) {
      return e.toString();
    }
  }

  // -----------------------------
  // 🔵 Get Friend List
  // -----------------------------
  Stream<List<String>> getFriends() {
    return _db.collection('friends').doc(uid).snapshots().map((doc) {
      if (!doc.exists) return [];
      return (doc.data()!.keys.toList());
    });
  }

  // -----------------------------
  // 🔵 Remove Friend
  // -----------------------------
  Future<void> removeFriend(String friendId) async {
    await _db.collection('friends').doc(uid).update({
      friendId: FieldValue.delete(),
    });
  }
}
