import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // डेट फॉर्मेटिंग के लिए (pubspec.yaml में intl पैकेज हो तो अच्छा है, नहीं तो नीचे वाला simple format use करें)
import 'create_note_page.dart'; // अपनी CreateNotePage फाइल को यहाँ import करें

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Timeline"),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),

      // Floating Button to Add New Note
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateNotePage()),
          );
        },
      ),

      body: StreamBuilder<QuerySnapshot>(
        // 'notes' कलेक्शन से डेटा लाएं, और टाइम के हिसाब से sort करें (Newest First)
        stream: FirebaseFirestore.instance
            .collection('notes')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          // 1. Loading State
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 2. Error State
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final docs = snapshot.data?.docs ?? [];

          // 3. Empty State
          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.notes, size: 60, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("No notes found on timeline.", style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }

          // 4. Data List
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final noteId = docs[index].id;

              // डेटा निकालें (Null safety के साथ)
              final title = data['title'] ?? 'No Title';
              final content = data['content'] ?? '';
              final Timestamp? timestamp = data['createdAt']; // Firestore Timestamp

              return TimelineCard(
                title: title,
                content: content,
                timestamp: timestamp,
                onTap: () {
                  // कार्ड पर क्लिक करने पर एडिट पेज पर जाएं
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateNotePage(
                        noteId: noteId,
                        existingData: data,
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

// --- Custom Card Design for Timeline ---
class TimelineCard extends StatelessWidget {
  final String title;
  final String content;
  final Timestamp? timestamp;
  final VoidCallback onTap;

  const TimelineCard({
    super.key,
    required this.title,
    required this.content,
    this.timestamp,
    required this.onTap,
  });

  // डेट को सिंपल स्ट्रिंग में बदलने के लिए फंक्शन
  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return "Just now";
    DateTime date = timestamp.toDate();
    // अगर आपके पास intl पैकेज नहीं है, तो यह बेसिक फॉर्मेट है:
    return "${date.day}/${date.month}/${date.year} • ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon + Date
              Row(
                children: [
                  const CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.deepPurple,
                    child: Icon(Icons.person, size: 16, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _formatDate(timestamp),
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Title
              if (title.isNotEmpty)
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),

              // Content
              if (content.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  content,
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                  maxLines: 4, // ज्यादा बड़ा टेक्स्ट हो तो 4 लाइन बाद ... दिखाएगा
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
