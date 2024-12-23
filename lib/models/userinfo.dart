class UserInfo {
  final String userName;
  final String profileImagePath;

  UserInfo({
    required this.userName,
    required this.profileImagePath,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userName: json['userName'] ?? '',
      profileImagePath: json['profileImage_path'] ?? '',
    );
  }
}