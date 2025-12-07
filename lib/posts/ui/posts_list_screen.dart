Widget _buildPostCard(PostModel post) {
  return Card(
    elevation: 3,
    margin: const EdgeInsets.only(bottom: 14),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: Padding(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// User ID
          Text(
            "User: ${post.userId}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),

          const SizedBox(height: 8),

          /// Post Content
          Text(
            post.content,
            style: const TextStyle(fontSize: 16),
          ),

          const SizedBox(height: 10),

          /// Post Image (optional)
          if (post.imageUrl != null && post.imageUrl!.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                post.imageUrl!,
                fit: BoxFit.cover,
              ),
            ),

          const SizedBox(height: 10),

          /// Date
          Text(
            "Posted on: ${post.createdAt.toLocal()}",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),

          const SizedBox(height: 12),

          // ============================================
          // LIKE BUTTON + LIKE COUNT
          // ============================================
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
                    "demo_user_123", // TODO: Replace with Firebase user ID
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

          // ============================================
          // COMMENTS BUTTON
          // ============================================
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
