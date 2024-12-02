import 'dart:convert';
import 'package:app_chat/ui/storypage.dart';
import 'package:http/http.dart' as http;
import '../model/story.dart';

 class CallingAPI {

//api lay story
static  Future<List<Story>> fetchStories() async {
    final response = await http.get(
        Uri.parse('http://192.168.67.106:8080/api/story/getstories'));

    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((story) => Story.fromJson(story)).toList();
    } else {
      throw Exception('Failed to load stories');
    }
  }
}