import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String fullName;
  final String username;
  final String profileImagePath;

  User({required this.fullName, required this.username, required this.profileImagePath});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullName'] ?? '',
      username: json['username'] ?? '',
      profileImagePath: json['profileImagePath'] ?? '',
    );
  }
}


