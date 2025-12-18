import 'package:cloud_firestore/cloud_firestore.dart';

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
  /// JSON → Model (API / old flow)
  /// -----------------------------
  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json["_id"]?.toString() ?? "",
      postId: json["postId"]?.toString() ?? "",
      userId: json["userId"]?.toString() ?? "",
      text: json["text"] ?? "",
      createdAt:
      DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
    );
  }

  /// -----------------------------
  /// FIRESTORE → Model (NEW FLOW)
  /// -----------------------------
  factory CommentModel.fromMap(Map<String, dynamic> map) {
    return CommentModel(
      id: map['id'] ?? '',
      postId: map['postId'] ?? '',
      userId: map['userId'] ?? '',
      text: map['text'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
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
