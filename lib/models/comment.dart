import 'dart:convert';
import 'dart:math';

import 'package:faker/faker.dart';
import 'package:quick_social/models/models.dart';

class Comment {
  String id; // Unique identifier for the comment
  String fullName; // ID of the post the comment belongs to
  String text; // Content of the comment


  Comment({
    required this.id,
    required this.fullName,
    required this.text,
  });

  // Method to convert from JSON to Comment
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      fullName: json['fullName'] ?? '',
      text: json['text'] ?? '',
    );
  }

  // Method to convert from Comment to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'text': text,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
