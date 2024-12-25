class UserDTO {
  String fullName;
  int gender;
  String profileImagePath;

  UserDTO(
      {required this.fullName,
      required this.gender,
      required this.profileImagePath});

  //ep kieu tu json sang object
  factory UserDTO.fromJson(Map<String, dynamic> json) {
    return UserDTO(
        fullName: json['fullName'] as String,
        gender: json['gender'] as int,
        profileImagePath: json['profileImagePath'] as String);
  }

  // ep kieu tu object sang json
  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'gender': gender,
      'profileImagePath': profileImagePath
    };
  }
}
