import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quick_social/models/models.dart';

import '../config/AppConfig.dart';
import '../models/post.dart';
class SocialPostWidget extends StatefulWidget {
  final String postId;
  SocialPostWidget({required this.postId});

  @override
  _SocialPostWidgetState createState() => _SocialPostWidgetState();
}

class _SocialPostWidgetState extends State<SocialPostWidget> {
  bool isLiked = false;
  late Future<Post> postFuture;

  @override
  void initState() {
    super.initState();
    postFuture = getPostById(widget.postId);
  }

  Future<Post> getPostById(String id) async {
    String apiUrl = "${AppConfig.baseUrl}";
    final response = await http.get(Uri.parse('$apiUrl/api/post/get/$id'));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      return Post.fromJson(data);
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: FutureBuilder<Post>(
        future: postFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            Post post = snapshot.data!;
            return buildPostContent(post);
          } else {
            return const Center(child: Text('No data found'));
          }
        },
      ),
    );
  }

  Widget buildPostContent(Post post) {
    return Column(
      children: [
        const SizedBox(height: 50),
        Card(
          elevation: 4,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(post.user.profileImagePath),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            post.user.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            post.caption,
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text(
                  post.caption,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  post.media,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                      child: Icon(
                        isLiked ? Icons.favorite : Icons.favorite_border,
                        color: isLiked ? Colors.red : Colors.black,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('${post.likeCount}'),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.chat_bubble_outline, size: 24),
                      onPressed: () {},
                    ),
                    Text('${post.comments}'),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.repeat, size: 24),
                      onPressed: () {},
                    ),
                    Text('${post.saveCount}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
