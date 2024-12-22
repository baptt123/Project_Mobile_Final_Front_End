import 'dart:convert';
import 'package:app_chat/ui/storypage.dart';
import 'package:http/http.dart' as http;
import '../model/friend.dart';
import '../model/story.dart';

 class CallingAPI {

//api lay story
static  Future<List<Story>> fetchStories() async {
    final response = await http.get(
        Uri.parse('http://192.168.14.106:8080/api/story/getstories'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((story) => Story.fromJson(story)).toList();
    } else {
      throw Exception('Failed to load stories');
    }
  }

// follow/unfollow
 static  Future<bool> followUser(String followerId, String followingId) async {
  // final response = await http.get(Uri.parse('http://192.168.14.17:8080/api/follow'));
     final url = Uri.parse('http://192.168.14.17:8080/api/follow');
     final response = await http.post(
       url,
       headers: {'Content-Type': 'application/json'},
       body: jsonEncode({
         'followerId': followerId,
         'followingId': followingId,
       }),
     );
     return response.statusCode == 200;
   }

  static Future<bool> unfollowUser(String followerId, String followingId) async {
     final url = Uri.parse('http://192.168.14.17:8080/api/follow');
     final request = http.Request('DELETE', url)
       ..headers['Content-Type'] = 'application/json'
       ..body = jsonEncode({
         'followerId': followerId,
         'followingId': followingId,
       });

     final response = await request.send();
     return response.statusCode == 200;
   }

   // Ds ban be
   static Future<List<Friend>> fetchFriends() async{
     final response = await http.get(Uri.parse('http://192.168.14.17:8080/api/friend'));
     if(response.statusCode == 200){
       List<dynamic> data = jsonDecode(response.body);
       return data.map((json) => Friend.fromJSON(json)).toList();

     } else{
       throw Exception('Failed to load friends');
     }
   }
   static Future<void> addFriend(Friend newFriend) async {
     final response = await http.post(
       Uri.parse('http://192.168.14.17:8080/api/friend'),
       headers: {'Content-Type': 'application/json'},
       body: jsonEncode(newFriend.toJSON()),
     );

     if (response.statusCode == 200) {
       print('Friend added successfully!');
     } else {
       throw Exception('Failed to add friend');
     }
   }
   static Future<void> deleteFriend(int friendId) async {
     final response = await http.delete(
       Uri.parse('http://192.168.14.17:8080/api/friend/$friendId'),
     );

     if (response.statusCode == 200) {
       print('Friend deleted successfully!');
     } else {
       throw Exception('Failed to delete friend');
     }
   }
}
