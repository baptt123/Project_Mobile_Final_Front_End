import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quick_social/config/AppConfig.dart';

import '../dto/notificationsdto.dart';
import '../dto/postdto.dart';
import '../dto/storydto.dart';
import '../dto/userdto.dart';
import '../models/post.dart';
import '../models/story.dart';

class CallingAPI {
  static const String postURL =
      'http://192.168.1.13:8080/api/post/getpost'; // URL API
  static const String storyURL =
      'http://192.168.1.13:8080/api/story/getstories';
  static const String notificationURL =
      'http://192.168.1.13:8080/api/notification/get-notification';
  static const String messagesURL =
      'http://192.168.1.13:8080/api/messages/getmessages';
  static const String SearchURL =
      'http://192.168.1.13:8080/api/user/getsearch';
  static const String LikeURL =
      'http://192.168.1.13:8080/api/post/get/updateLike/{id}';


  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse(postURL));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  Future<Map<String, dynamic>> updatePost(String postId,
      {bool? isLike, bool? isSaved}) async {
    final response = await http.put(
      Uri.parse('$LikeURL/$postId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'isLike': isLike != null ? (isLike ? 1 : 0) : null,
        'isSaved': isSaved != null ? (isSaved ? 1 : 0) : null,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update post');
    }
  }

  // Phương thức GET: Lấy danh sách StoryDTO
  static Future<List<Story>> fetchStories() async {
    final response = await http.get(Uri.parse(storyURL));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Story.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load stories');
    }
  }

  static Future<List<NotificationsDTO>> fetchNotifications() async {
    final response = await http.get(Uri.parse(notificationURL));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => NotificationsDTO.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load notifications");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchMessages() async {
    final response = await http.get(Uri.parse(messagesURL));
    if (response.statusCode == 200) {
      final List<dynamic> fetchedMessages = json.decode(response.body);
      return fetchedMessages
          .map((message) => {
                'id': message['id'],
                'sender': message['idSender'],
                'text': message['message'],
                'sendingDate': DateTime.parse(message['sendingDate']),
              })
          .toList();
    } else {
      throw Exception('Failed to fetch messages: ${response.statusCode}');
    }
  }

  static Future<List<UserDTO>> fetchUsersAdmin() async {
    final response =
        await http.get(Uri.parse(AppConfig.baseUrl + AppConfig.userURL));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((user) => UserDTO.fromJson(user)).toList();
    } else {
      throw Exception('Failed to fetch users: ${response.statusCode}');
    }
  }

  static Future<List<PostDTO>> fetchPostsAdmin() async {
    final response = await http.get(Uri.parse(AppConfig.baseUrl+AppConfig.postURL));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((post) => PostDTO.fromJson(post)).toList();
    } else {
      throw Exception('Failed to fetch user at admin:${response.statusCode}');
    }
  }





  static const String baseUrl = 'http://localhost:8080/api/users';

  // Tìm kiếm người dùng
  static Future<List<UserDTO>> fetchSearchUsers(String name, {String? excludeUserId}) async {
    final Uri uri = Uri.parse('$SearchURL/search').replace(queryParameters: {
      'name': name,
      if (excludeUserId != null) 'excludeUserId': excludeUserId,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => UserDTO.fromJson(json)).toList();
    } else {
      throw Exception('Failed to find users');
    }
  }

}
