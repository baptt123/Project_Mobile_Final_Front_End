import 'dart:convert';
import 'package:http/http.dart' as http;

import '../dto/notificationsdto.dart';
import '../dto/postdto.dart';
import '../dto/storydto.dart';
class CallingAPI {
  static const String postURL = 'http://192.168.0.118:8080/api/post/getpost'; // URL API
  static const String storyURL= 'http:// 192.168.0.118:8080/api/story/getstories';
  static const String notificationURL='http:// 192.168.0.118:8080/api/notification/get-notification';
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
  static Future<List<StoryDTO>> fetchStories() async {
    final response = await http.get(Uri.parse(storyURL));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => StoryDTO.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load stories');
    }
  }
  static Future<List<NotificationsDTO>> fetchNotifications() async{
    final response = await http.get(Uri.parse(notificationURL));
    if(response.statusCode==200){
      final List<dynamic> data=json.decode(response.body);
      return data.map((json)=> NotificationsDTO.fromJson(json)).toList();
    }else{
      throw Exception("Failed to load notifications");
    }
  }
}
