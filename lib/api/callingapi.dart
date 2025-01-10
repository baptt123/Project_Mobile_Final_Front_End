import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_social/config/AppConfig.dart';

import '../dto/notificationsdto.dart';
import '../dto/postdto.dart';
import '../dto/storydto.dart';
import '../dto/userdto.dart';
import '../models/story.dart';

class CallingAPI {
  static const String postURL =
      'http://192.168.15.62:8080/api/post/getpost'; // URL API
  static const String storyURL =
      'http://192.168.15.62:8080/api/story/getstories';
  static const String notificationURL =
      'http://192.168.15.62:8080/api/notification/get-notification';
  static String messagesURL =
      'http://192.168.15.62:8080/api/messages/getmessages';

  static Future<List<PostDTO>> fetchPosts() async {
    final response = await http.get(Uri.parse(postURL));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PostDTO.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
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

  static Future<List<Map<String, dynamic>>> fetchMessages(
      String userNameSender, String userNameReceiver) async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.15.62:8080/api/messages/getmessages'+'/'+userNameSender+'/'+userNameReceiver)
        ,
      );

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return [];
        }

        List<dynamic> jsonData = json.decode(response.body);

        if (jsonData.isEmpty) {
          return [];
        }

        return jsonData.map((message) => {
          'id': message['id'] ?? '',
          'userNameSender': message['userNameSender'] ?? '',
          'text': message['message'] ?? '',
          'sendingDate': message['sendingDate'] != null
              ? DateTime.parse(message['sendingDate'])
              : DateTime.now(),
        }).toList();
      } else if (response.statusCode == 204) {
        return [];
      } else {
        print('Error: Status code ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
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
    final response =
    await http.get(Uri.parse(AppConfig.baseUrl + AppConfig.postURL));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((post) => PostDTO.fromJson(post)).toList();
    } else {
      throw Exception('Failed to fetch user at admin:${response.statusCode}');
    }
  }
}
