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
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<List<String>>(
        stream: service.getFriends(),
        builder: (context, snapshot) {
          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error State
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final friends = snapshot.data ?? [];

          // 3. Empty State
          if (friends.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "You haven't added any friends yet.",
                    style: TextStyle(fontSize: 18, color: Colors.black54),
                  ),
                ],
              ),
            );
          }

          // 4. List View
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: friends.length,
            itemBuilder: (context, index) {
              final friendId = friends[index];

              // हर आइटम के लिए अलग Widget का उपयोग करें (Performance के लिए बेहतर)
              return FriendListTile(
                friendId: friendId,
                service: service,
              );
            },
          );
        },
      ),
    );
  }
}

// --- Separate Widget for List Item (Better Performance) ---
class FriendListTile extends StatelessWidget {
  final String friendId;
  final FriendService service;

  const FriendListTile({
    super.key,
    required this.friendId,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance.collection('users').doc(friendId).get(),
      builder: (context, userSnapshot) {
        if (!userSnapshot.hasData) {
          // लोडिंग के दौरान एक खाली कार्ड दिखाएं ताकि UI खराब न लगे
          return const Card(
            child: ListTile(
              title: Text("Loading..."),
              leading: CircleAvatar(backgroundColor: Colors.grey),
            ),
          );
        }

        if (userSnapshot.hasError || !userSnapshot.data!.exists) {
          return const SizedBox(); // अगर यूजर डिलीट हो चुका है, तो कुछ न दिखाएं
        }

        final userData = userSnapshot.data!.data() as Map<String, dynamic>?;
        final email = userData?['email'] ?? "Unknown";
        final name = userData?['name'] ?? "Friend";

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 6),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.deepPurple.shade100,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                    color: Colors.deepPurple, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(email),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () {
                // Confirm before deleting (Delete popup)
                _showDeleteDialog(context, friendId);
              },
            ),
          ),
        );
      },
    );
  }

  void _showDeleteDialog(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Remove Friend?"),
        content: const Text("Are you sure you want to remove this friend?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              service.removeFriend(id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Friend removed")),
              );
            },
            child: const Text("Remove", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
