class UserModel {
  final String id;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? bio;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.bio,
    required this.createdAt,
  });

  /// JSON → Model
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"]?.toString() ?? "",
      name: json["name"] ?? "",
      email: json["email"] ?? "",
      profileImageUrl: json["profileImageUrl"],
      bio: json["bio"],
      createdAt:
      DateTime.tryParse(json["createdAt"] ?? "") ?? DateTime.now(),
    );
  }

  /// Model → JSON
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "name": name,
      "email": email,
      "profileImageUrl": profileImageUrl,
      "bio": bio,
      "createdAt": createdAt.toIso8601String(),
    };
  }
}
