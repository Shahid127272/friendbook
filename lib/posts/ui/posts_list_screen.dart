import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../model/post_model.dart';
import '../provider/post_provider.dart';
import 'comments_screen.dart';

Widget _buildPostCard(BuildContext context, PostModel post) {
  return Card(
    elevation: 3,
    margin: const EdgeInsets.only(bottom: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// =========================
          /// USER ID
          /// =========================
          Text(
            "User: ${post.userId}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 8),

          /// =========================
          /// POST CONTENT
          /// =========================
          Text(
            post.content,
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 10),

          /// =========================
          /// POST IMAGE (OPTIONAL)
          /// =========================
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.imageUrl!,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Center(child: Icon(Icons.broken_image)),
                  );
                },
              ),
            ),

          const SizedBox(height: 10),

          /// =========================
          /// POST DATE (FORMATTED)
          /// =========================
          Text(
            "Posted on: ${DateFormat('dd MMM yyyy, hh:mm a').format(post.createdAt)}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 12),

          /// =========================
          /// LIKE BUTTON + COUNT
          /// =========================
          Row(
            children: [
              IconButton(
                icon: Icon(
                  post.isLikedByMe
                      ? Icons.favorite
                      : Icons.favorite_border,
                  color: post.isLikedByMe ? Colors.red : Colors.grey,
                ),
                onPressed: () {
                  final provider =
                  Provider.of<PostProvider>(context, listen: false);

                  provider.toggleLike(
                    post.id,
                    "demo_user_123", // TODO: Firebase user ID
                  );
                },
              ),
              Text(
                "${post.likes.length} Likes",
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),

          const SizedBox(height: 6),

          /// =========================
          /// COMMENTS BUTTON
          /// =========================
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.comment_outlined),
                color: Colors.blueGrey,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CommentsScreen(postId: post.id),
                    ),
                  );
                },
              ),
              const Text(
                "Comments",
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
