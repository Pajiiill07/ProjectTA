class UserModel {
  final int userId;
  final String username;
  final String email;
  final String role;
  final String? photoUrl;

  UserModel({
    required this.userId,
    required this.username,
    required this.email,
    required this.role,
    this.photoUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    try {
      return UserModel(
        userId: json["user_id"] is int ? json["user_id"] : int.parse(json["user_id"].toString()),
        username: json["username"]?.toString() ?? "",
        email: json["email"]?.toString() ?? "",
        role: json["role"]?.toString() ?? "",
        photoUrl: json["photo_url"]?.toString(),
      );
    } catch (e) {
      print("Error parsing UserModel: $e");
      print("JSON data: $json");
      rethrow;
    }
  }

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "username": username,
    "email": email,
    "role": role,
    "photo_url": photoUrl,
  };
}