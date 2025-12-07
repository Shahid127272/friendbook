class PostModel {
  final String id;
  final String userId;
  final String content;
  final String? imageUrl;
  final DateTime createdAt;

  // LIKE SYSTEM FIELDS (NEW)
  final List<String> likes;
  bool isLikedByMe;

  PostModel({
    required this.id,
    required this.userId,
    required this.content,
    this.imageUrl,
    required this.createdAt,
    required this.likes,              // NEW
    this.isLikedByMe = false,         // NEW
  });

  /// -----------------------------
  /// Convert JSON → Model
  /// -----------------------------
  factory PostModel.fromJson(Map<String, dynamic> json) {
    // Likes list parse karein (safety ke saath)
    List<String> likesList = [];
    if (json["likes"] != null) {
      likesList = List<String>.from(json["likes"].map((e) => e.toString()));
    }

    // TEMP: current user (Later Hum Firebase User ID se replace karenge)
    String currentUserId = "demo_user_123";

    return PostModel(
      id: json["_id"]?.toString() ?? "",
      userId: json["userId"]?.toString() ?? "",
      content: json["content"] ?? "",
      imageUrl: json["imageUrl"],
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),

      likes: likesList,
      isLikedByMe: likesList.contains(currentUserId),
    );
  }

  /// -----------------------------
  /// Convert Model → JSON
  /// -----------------------------
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "userId": userId,
      "content": content,
      "imageUrl": imageUrl,
      "createdAt": createdAt.toIso8601String(),

      "likes": likes, // NEW
    };
  }
}
