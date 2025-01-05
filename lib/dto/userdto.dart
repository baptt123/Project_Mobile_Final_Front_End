class UserDTO {
  String? fullName; // Đổi thành nullable String
  int gender; // gender vẫn giữ nguyên vì có thể không null
  String? profileImagePath; // Đổi thành nullable String

  UserDTO(
      {this.fullName, // Thay đổi `required` thành nullable
        required this.gender,
        this.profileImagePath}); // Thay đổi `required` thành nullable

  // Ep kiểu từ json sang object
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
        fullName: json['fullName'] as String?, // Lấy giá trị nullable từ JSON
        gender: json['gender'] as int,
        profileImagePath: json['profileImagePath'] as String?); // Lấy giá trị nullable từ JSON
  }

  // Ep kiểu từ object sang json
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName, // Không cần ép kiểu vì nullable
      'gender': gender,
      'profileImagePath': profileImagePath, // Không cần ép kiểu vì nullable
    };
  }
}

