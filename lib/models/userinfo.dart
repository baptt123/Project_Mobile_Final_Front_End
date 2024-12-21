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
  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'profileImage_path': profileImagePath,
    };
  }
}