import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/AppConfig.dart';
import '../dto/notificationsdto.dart';
import '../dto/postdto.dart';
import '../dto/storydto.dart';
import '../dto/userdto.dart';
import '../models/friend.dart';
import '../models/post.dart';
import '../models/story.dart';
import '../models/user.dart';

class CallingAPIService {
  /// Fetch Stories
  static Future<List<Story>> fetchStories() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}${AppConfig.storyURL}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Story.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load stories');
    }
  }

  /// Fetch Notifications
  static Future<List<NotificationsDTO>> fetchNotifications() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}${AppConfig.notificationURL}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => NotificationsDTO.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load notifications");
    }
  }

  /// Fetch Messages
  static Future<List<Map<String, dynamic>>> fetchMessages(String sender, String receiver) async {
    try {
      final response = await http.get(Uri.parse('${AppConfig.baseUrl}${AppConfig.messageURL}/$sender/$receiver'));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
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
        return [];
      }
    } catch (e) {
      print('Error fetching messages: $e');
      return [];
    }
  }

  /// Admin fetch users
  static Future<List<UserDTO>> fetchUsersAdmin() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}${AppConfig.userURL}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((user) => UserDTO.fromJson(user)).toList();
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  /// Admin fetch posts
  static Future<List<PostDTO>> fetchPostsAdmin() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}${AppConfig.postURL}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((post) => PostDTO.fromJson(post)).toList();
    } else {
      throw Exception('Failed to fetch posts');
    }
  }

  /// Gợi ý kết bạn
  Future<List<Friend>> fetchSuggestedFriends(String userId) async {
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/user/suggested-friends/$userId');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Friend.fromJSON(json)).toList();
    } else {
      throw Exception("Failed to load suggested friends");
    }
  }

  /// Follow / Unfollow
  Future<void> followUser(String currentUserId, String targetUserId) async {
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/user/$currentUserId/follow/$targetUserId');
    final response = await http.post(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to follow user');
    }
  }

  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/user/$currentUserId/unfollow/$targetUserId');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception('Failed to unfollow user');
    }
  }

  Future<List<Friend>> fetchFollowers(String userId) async {
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/user/$userId/followers');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Friend.fromJSON(json)).toList();
    } else {
      throw Exception("Failed to load followers");
    }
  }

  Future<List<Friend>> fetchFriends(String userId) async {
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/user/$userId/friends');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Friend.fromJSON(json)).toList();
    } else {
      throw Exception("Failed to load friends");
    }
  }

  Future<List<Friend>> fetchFollowing(String userId) async {
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/user/$userId/following');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Friend.fromJSON(json)).toList();
    } else {
      throw Exception("Failed to load following");
    }
  }

  /// Gửi bình luận
  static Future<void> submitComment({
    required String postId,
    required String id,
    required String fullName,
    required String text,
  }) async {
    try {
      final url = Uri.parse('${AppConfig.commentUrl}/api/post/get/$postId/comments');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': id,
          'fullName': fullName,
          'text': text,
        }),
      );
      if (response.statusCode == 200) {
        print('✅ Comment added successfully!');
      } else {
        throw Exception('❌ Failed to add comment: ${response.body}');
      }
    } catch (e) {
      print('⚠️ Error while adding comment: $e');
      rethrow;
    }
  }

  /// Fetch bài viết
  static Future<List<Post>> fetchPosts() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}${AppConfig.postURL}'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load posts');
    }
  }

  /// Like bài viết
  Future<Map<String, dynamic>> updatePost(String postId, {
    bool? isLike,
    bool? isSaved,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}${AppConfig.likeURL}/$postId');
    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'isLike': isLike != null ? (isLike ? 1 : 0) : null,
      }),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update post');
    }
  }

  /// Tìm kiếm người dùng
  static Future<List<User>> fetchSearchUsers(String query, {String? excludeUserId}) async {
    final uri = Uri.parse('${AppConfig.baseUrl}${AppConfig.searchURL}').replace(queryParameters: {
      'q': query,
      if (excludeUserId != null) 'excludeUserId': excludeUserId,
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((json) => User.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      return [];
    } else {
      throw Exception('Failed to search users');
    }
  }

  /// CRUD bạn bè (Thêm, Cập nhật, Xoá)
  static Future<void> addFriend(Map<String, dynamic> friendData) async {
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/friend');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(friendData),
    );
    if (response.statusCode != 200) {
      throw Exception("Error adding friend: ${response.statusCode}");
    }
  }

  static Future<void> updateFriend(String id, Map<String, dynamic> updatedData) async {
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/friend/$id');
    final response = await http.put(
      url,
      headers: {"Content-Type": "application/json"},
      body: json.encode(updatedData),
    );
    if (response.statusCode != 200) {
      throw Exception("Error updating friend: ${response.statusCode}");
    }
  }

  static Future<void> deleteFriend(String id) async {
    final url = Uri.parse('${AppConfig.friendbaseUrl}/api/friend/$id');
    final response = await http.delete(url);
    if (response.statusCode != 200) {
      throw Exception("Error deleting friend: ${response.statusCode}");
    }
  }
}
