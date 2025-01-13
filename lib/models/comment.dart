import 'dart:convert';

class Comment {
  String id; // Unique identifier for the comment
  String fullname; // ID of the post the comment belongs to
  String text; // Content of the comment


  Comment({
    required this.id,
   required this.fullname,
    required this.text,
  });

  // Method to convert from JSON to Comment
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] ?? '',
      fullname: json['fullname'] ?? '',
      text: json['text'] ?? '',
    );
  }

  // Method to convert from Comment to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullname': fullname,
      'text': text,
    };
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}
