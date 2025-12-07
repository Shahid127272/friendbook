import 'package:flutter/material.dart';
import '../auth/auth_service.dart';
import '../friends/friends_list_page.dart';
import '../friends/add_friend_page.dart';
import '../notes/notes_list_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String userName = "";
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  // ⭐ Temporary dummy function (Phase 8 ke baad real data aayega)
  void loadUserData() async {
    // final data = await AuthService().getUserData(); // ❌ Old function removed

    // ❗ App crash na ho isliye safe dummy variable
    var data = null;

    if (data != null) {
      setState(() {
        userName = data["name"] ?? "";
        userEmail = data["email"] ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: const Text("FriendBook"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddFriendPage()),
              );
            },
            icon: const Icon(Icons.person_add),
          ),
          IconButton(
            onPressed: () async {
              await AuthService().logout();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ⭐ Profile Header
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.deepPurple,
                  child: Text(
                    userName.isNotEmpty ? userName[0].toUpperCase() : "?",
                    style: const TextStyle(
                      fontSize: 26,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 15),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userName.isNotEmpty ? userName : "Loading...",
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    Text(
                      userEmail,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 30),

            const Text(
              "Your Tools",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 20),

            dashboardButton(
              icon: Icons.group,
              label: "View Friends",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const FriendsListPage()),
                );
              },
            ),

            const SizedBox(height: 15),

            dashboardButton(
              icon: Icons.person_add,
              label: "Add Friend",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AddFriendPage()),
                );
              },
            ),

            const SizedBox(height: 15),

            dashboardButton(
              icon: Icons.note,
              label: "Notes",
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NotesListPage()),
                );
              },
            ),

            const SizedBox(height: 15),

            dashboardButton(
              icon: Icons.photo_library,
              label: "Posts / Timeline",
              onTap: () {},
            ),

            const SizedBox(height: 15),

            dashboardButton(
              icon: Icons.chat,
              label: "Chat",
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget dashboardButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.deepPurple.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28, color: Colors.deepPurple),
            const SizedBox(width: 20),
            Text(label, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
