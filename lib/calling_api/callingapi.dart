import 'dart:convert';
// import 'package:app_chat/ui/storypage.dart';
// import 'package:app_chat/ui/storypage.dart';
import 'package:http/http.dart' as http;
import '../model/friend.dart';
import '../model/story.dart';

class CallingAPIFriends {

//api lay story
 static  Future<List<Story>> fetchStories() async {
  final response = await http.get(
      Uri.parse('http://192.168.88.231:8080/api/story/getstories'));

  if (response.statusCode == 200) {
   List jsonResponse = json.decode(response.body);
   return jsonResponse.map((story) => Story.fromJson(story)).toList();
  } else {
   throw Exception('Failed to load stories');
  }
 }

 static const String baseUrl = 'http://192.168.1.109:8080/api/friend';

 // Lấy danh sách bạn bè
 // static Future<List<Map<String, dynamic>>> fetchFriends() async {
 //  final url = Uri.parse(baseUrl);
 //  try {
 //   final response = await http.get(url);
 //   if (response.statusCode == 200) {
 //    return List<Map<String, dynamic>>.from(json.decode(response.body));
 //   } else {
 //    throw Exception("Error fetching friends: ${response.statusCode}");
 //   }
 //  } catch (e) {
 //   throw Exception("Error: $e");
 //  }
 // }

 // Thêm bạn bè mới
 static Future<void> addFriend(Map<String, dynamic> friendData) async {
  final url = Uri.parse(baseUrl);
  try {
   final response = await http.post(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(friendData),
   );
   if (response.statusCode != 200) {
    throw Exception("Error adding friend: ${response.statusCode}");
   }
  } catch (e) {
   throw Exception("Error: $e");
  }
 }

 // Cập nhật bạn bè
 static Future<void> updateFriend(String id, Map<String, dynamic> updatedData) async {
  final url = Uri.parse('$baseUrl/$id');
  try {
   final response = await http.put(
    url,
    headers: {"Content-Type": "application/json"},
    body: json.encode(updatedData),
   );
   if (response.statusCode != 200) {
    throw Exception("Error updating friend: ${response.statusCode}");
   }
  } catch (e) {
   throw Exception("Error: $e");
  }
 }

 // Xóa bạn bè
 static Future<void> deleteFriend(String id) async {
  final url = Uri.parse('$baseUrl/$id');
  try {
   final response = await http.delete(url);
   if (response.statusCode != 200) {
    throw Exception("Error deleting friend: ${response.statusCode}");
   }
  } catch (e) {
   throw Exception("Error: $e");
  }
 }

 // Future<List<Friend>> fetchSuggestedFriends(String userId) async {
 //  final response = await http.get(Uri.parse('http://192.168.1.183:8080/api/user/suggested-friends/$userId'));
 //
 //  if (response.statusCode == 200) {
 //   final List<dynamic> data = json.decode(response.body);
 //   return data.map((json) => Friend.fromJSON(json)).toList();
 //  } else {
 //   throw Exception("Failed to load suggested friends");
 //  }
 // }
 //Phan hien thi goi ý ket ban be
  Future<List<Friend>> fetchSuggestedFriends(String userId) async {
  //192.168.1.183
  // final url = Uri.parse('http://192.168.88.234:8080/api/user/suggested-friends/$userId');
   final url = Uri.parse('http://192.168.67.102:8080/api/user/suggested-friends/$userId');

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
  final url = Uri.parse('http://192.168.67.102:8080/api/user/${currentUserId}/follow/${targetUserId}');
  final response = await http.post(url);
  if (response.statusCode != 200) {
   throw Exception('Failed to follow user');
  }
 }

 // Unfollow user
  Future<void> unfollowUser(String currentUserId, String targetUserId) async {
  final url = Uri.parse('http://192.168.67.102:8080/api/user/${currentUserId}/unfollow/${targetUserId}');
  final response = await http.delete(url);
  if (response.statusCode != 200) {
   throw Exception('Failed to unfollow user');
  }
 }
 Future<List<Friend>> fetchFollowers(String userId) async {
  final url = Uri.parse('http://192.168.67.102:8080/api/user/$userId/followers');

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
  final url = Uri.parse('http://192.168.67.102:8080/api/user/$userId/friends');

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
  final url = Uri.parse('http://192.168.67.102:8080/api/user/$userId/following');

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
// call api hien thi followers
// Future<List<Friend>> fetchfollowers(String userId) async{
//   final response = await http.get(
//    Uri.parse('http://192.168.60.70:8080/followers?userId=$userId'),
//    headers: {'Content-Type': 'application/json'},
//   );
//
//   if (response.statusCode == 200) {
//    final List<dynamic> data = jsonDecode(response.body);
//    return data.map((json) => Friend.fromJSON(json)).toList();
//   } else {
//    throw Exception('Failed to load followers');
//   }
// }
// // call api hiển thị following
//  Future<List<Friend>> fetchfollowing(String userId) async {
//   final response = await http.get(
//    Uri.parse('http://192.168.60.70:8080/followers?userId=$userId'),
//    headers: {'Content-Type': 'application/json'},
//   );
//  if (response.statusCode == 200) {
//   final List<dynamic> data = jsonDecode(response.body);
//   return data.map((json) => Friend.fromJSON(json)).toList();
//  } else {
//   throw Exception('Failed to load followers');
//  }
// }



