


import 'package:quick_social/models/userinfo.dart';

import 'comment.dart';

class Post {
  final String id;
  final String caption;
  final UserInfo user;
  final int isLiked;
  final int likeCount;
  final int saveCount;
  final int shareCount;
  final String media;
  final List<Comment> comments; // Comments có thể là List hoặc null

  Post({
    required this.id,
    required this.caption,
    required this.user,
    required this.isLiked,
    required this.likeCount,
    required this.saveCount,
    required this.shareCount,
    required this.media,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    // Kiểm tra và thay thế null bằng một danh sách rỗng
    var comments = json['comments'];
    return Post(
      id: json['id'],
      caption: json['caption'],
      user: UserInfo.fromJson(json),
      likeCount: json['likeCount'],
      saveCount: json['saveCount'],
      shareCount: json['shareCount'],
      media: json['media'],
      comments: (json['comments'] as List<dynamic>?)
          ?.map((comment) => Comment.fromJson(comment))
          .toList() ??
          [],
      // If null, default to an empty list
      isLiked: 0, // Xử lý null cho comments
    );
  }

}