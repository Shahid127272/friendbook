import 'package:flutter/material.dart';
import 'friend_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FriendsListPage extends StatelessWidget {
  const FriendsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = FriendService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Friends"),
        backgroundColor: Colors.deepPurple,
      ),

      body: StreamBuilder<List<String>>(
        stream: service.getFriends(),
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final friends = snapshot.data ?? [];

          if (friends.isEmpty) {
            return const Center(
              child: Text(
                "You haven't added any friends yet.",
                style: TextStyle(fontSize: 18, color: Colors.black54),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(15),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friendId = friends[index];

              // Fetch friend's email and name using Firestore
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(friendId)
                    .get(),
                builder: (context, userSnapshot) {
                  if (!userSnapshot.hasData) {
                    return const ListTile(
                      title: Text("Loading..."),
                    );
                  }

                  final userData =
                  userSnapshot.data!.data() as Map<String, dynamic>?;

                  final email = userData?['email'] ?? "Unknown";
                  final name = userData?['name'] ?? "Friend";

                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Colors.deepPurple,
                        child: Icon(Icons.person, color: Colors.white),
                      ),
                      title: Text(name),
                      subtitle: Text(email),
                      trailing: IconButton(
                        icon: const Icon(Icons.remove_circle_outline,
                            color: Colors.red),
                        onPressed: () {
                          service.removeFriend(friendId);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
