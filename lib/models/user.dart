import 'dart:convert';

class User {
  String id;
  String username;
  String password;
  String email;
  String fullName;
  int gender; // 0: nam, 1: nữ
  int followersCount;
  int followingCount;
  int status; // 0: offline, 1: online
  String profileImagePath;
  List<String> friends; // Danh sách ID bạn bè
  List<String> postsSaved; // Danh sách bài viết đã lưu
  List<String> postsShared; // Danh sách bài viết đã chia sẻ
  List<String> followers;
  List<String> following;
  User({
    required this.id,
    required this.username,
    required this.password,
    required this.email,
    required this.fullName,
    required this.gender,
    required this.followersCount,
    required this.followingCount,
    required this.status,
    required this.profileImagePath,
    required this.friends,
    required this.postsSaved,
    required this.postsShared,
    required this.followers,
    required this.following
  });

  // Phương thức để chuyển đổi từ JSON sang User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      email: json['email'] ?? '',
      fullName: json['fullName'] ?? '',
      gender: json['gender'] ?? 0,
      followersCount: json['followersCount'] ?? 0,
      followingCount: json['followingCount'] ?? 0,
      status: json['status'] ?? 0,
      profileImagePath: json['profileImagePath'] ?? '',
      friends: List<String>.from(json['friends'] ?? []),
      postsSaved: List<String>.from(json['posts_saved'] ?? []),
      postsShared: List<String>.from(json['posts_shared'] ?? []),
      followers: List<String>.from(json['followers']??[]),
      following: List<String>.from(json['following']??[]),
    );
  }

  // Phương thức để chuyển đổi từ User sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'email': email,
      'fullName': fullName,
      'gender': gender,
      'followersCount': followersCount,
      'followingCount': followingCount,
      'status': status,
      'profileImagePath': profileImagePath,
      'friends': friends,
      'posts_saved': postsSaved,
      'posts_shared': postsShared,
      'followers':followers,
      'followings':following
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
