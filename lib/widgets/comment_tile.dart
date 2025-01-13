import 'package:flutter/material.dart';
import 'package:quick_social/models/post.dart';

class CommentWidget extends StatelessWidget {
  const CommentWidget({
    super.key,
    required this.post,
  });

  final Post post;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                child: Text(post.user.userName[0].toUpperCase()),
              ),
              const SizedBox(width: 8.0),
              Text(
                post.user.userName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Text(
            post.caption,
            style: const TextStyle(fontSize: 14.0),
          ),
          const SizedBox(height: 8.0),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.thumb_up_alt_outlined),
                onPressed: () {},
              ),
              Text('$post likes'),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }
}

