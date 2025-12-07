class CommentModel {
  final String id;
  final String postId;
  final String userId;
  final String text;
  final DateTime createdAt;

  CommentModel({
    required this.id,
    required this.postId,
    required this.userId,
    required this.text,
    required this.createdAt,
  });

  /// -----------------------------
  /// JSON → Model
  /// -----------------------------
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json["_id"]?.toString() ?? "",
      postId: json["postId"]?.toString() ?? "",
      userId: json["userId"]?.toString() ?? "",
      text: json["text"] ?? "",
      createdAt: DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
    );
  }

  /// -----------------------------
  /// Model → JSON
  /// -----------------------------
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "postId": postId,
      "userId": userId,
      "text": text,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}
