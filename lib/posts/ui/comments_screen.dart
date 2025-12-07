import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:friendbook/posts/provider/comment_provider.dart';
import 'package:friendbook/posts/models/comment_model.dart';

class CommentsScreen extends StatefulWidget {
  final String postId;

  const CommentsScreen({super.key, required this.postId});

  @override
  State<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();

    /// Jab screen open ho → comments load ho jayein
    Future.delayed(Duration.zero, () {
      Provider.of<CommentProvider>(context, listen: false)
          .loadComments(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CommentProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comments"),
        backgroundColor: Colors.deepPurple,
      ),

      body: Column(
        children: [
          /// ------------------------------
          /// Comments List
          /// ------------------------------
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.comments.isEmpty
                ? const Center(child: Text("No comments yet."))
                : ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: provider.comments.length,
              itemBuilder: (context, index) {
                final CommentModel c = provider.comments[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "User: ${c.userId}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(c.text),
                      const SizedBox(height: 6),
                      Text(
                        c.createdAt.toLocal().toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          /// ------------------------------
          /// Add Comment Box
          /// ------------------------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.1),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      hintText: "Write a comment...",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                CircleAvatar(
                  backgroundColor: Colors.deepPurple,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: Colors.white),
                    onPressed: () async {
                      final text = _commentController.text.trim();
                      if (text.isEmpty) return;

                      await provider.addComment(
                        postId: widget.postId,
                        userId: "demo_user_123", // TODO: Replace with real user ID
                        text: text,
                      );

                      _commentController.clear();
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
