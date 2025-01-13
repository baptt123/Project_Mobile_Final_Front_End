import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_social/config/AppConfig.dart';

import '../dto/notificationsdto.dart';
import '../dto/postdto.dart';
import '../dto/storydto.dart';
import '../dto/userdto.dart';
import '../model/friend.dart';
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
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}'+'${AppConfig.postURL}'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => PostDTO.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  // Phương thức GET: Lấy danh sách StoryDTO
  static Future<List<Story>> fetchStories() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}'+'${AppConfig.storyURL}'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Story.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load stories');
    }
  }

  static Future<List<NotificationsDTO>> fetchNotifications() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}'+'${AppConfig.notificationURL}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => NotificationsDTO.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load notifications");
    }
  }

  static Future<List<Map<String, dynamic>>> fetchMessages(
      String fullNameSender, String fullNameReceiver) async {
    try {
      final response = await http.get(
        Uri.parse('${AppConfig.baseUrl}'+AppConfig.messageURL+'/'+fullNameSender+'/'+fullNameReceiver)
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
          'fullNameSender': message['fullNameSender'] ?? '',
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
  //Phan hien thi goi ý ket ban be
  Future<List<Friend>> fetchSuggestedFriends(String userId) async {
    //192.168.1.183
    // final url = Uri.parse('http://192.168.88.234:8080/api/user/suggested-friends/$userId');
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/user/suggested-friends/$userId');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Chuyển đổi dữ liệu JSON từ API thành danh sách các đối tượng Friend
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Friend.fromJSON(json)).toList();
      } else {
        throw Exception("Failed to load suggested friends: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching suggested friends: $e");
    }
  }

// Call API follow và unfollow
//  final String baseUrl = "http://192.168.1.183:8080/api/user";
  // Follow user
  Future<void> followUser(String currentUserId, String targetUserId) async {
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/user/${currentUserId}/follow/${targetUserId}');
    final response = await http.post(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to follow user');
    }
  }

  // Unfollow user
  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/user/${currentUserId}/unfollow/${targetUserId}');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to unfollow user');
    }
  }
  Future<List<Friend>> fetchFollowers(String userId) async {
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/user/$userId/followers');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Chuyển đổi dữ liệu JSON từ API thành danh sách các đối tượng Friend
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Friend.fromJSON(json)).toList();
      } else {
        throw Exception("Failed to load followers: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching followers: $e");
    }
  }
  // Fetch danh sách bạn bè
  Future<List<Friend>> fetchFriends(String userId) async {
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/user/$userId/friends');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Chuyển đổi dữ liệu JSON từ API thành danh sách các đối tượng Friend
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Friend.fromJSON(json)).toList();
      } else {
        throw Exception("Failed to load friends: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching friends: $e");
    }
  }

// Fetch danh sách người đang theo dõi
  Future<List<Friend>> fetchFollowing(String userId) async {
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/user/$userId/following');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Chuyển đổi dữ liệu JSON từ API thành danh sách các đối tượng Friend
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Friend.fromJSON(json)).toList();
      } else {
        throw Exception("Failed to load following: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching following: $e");
    }
  }
}
