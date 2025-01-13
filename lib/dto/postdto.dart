import 'package:quick_social/models/comment.dart';

import '../models/userinfo.dart';

class PostDTO {
  final String caption;
  final String media;
  final UserInfo user;
  final String id;
  final int isLiked;
  final int likeCount;
  final int saveCount;
  final List<Comment> comments;

  PostDTO({
    required this.caption,
    required this.media,
    required this.user,
    required this.id,
    required this.isLiked,
    required this.likeCount,
    required this.saveCount,
    required this.comments,
  });

  factory PostDTO.fromJson(Map<String, dynamic> json) {
    return PostDTO(
      caption: json['caption'] ?? '',
      media: json['media'] ?? '',
      user: UserInfo.fromJson(json['user'] ?? {}),
      id: json['id']??'',
      likeCount: json['likeCount'],
      saveCount: json['saveCount'],
      comments: json['comments'] != null
          ? List<Comment>.from(json['comments'].map((item) => Comment.fromJson(item)))
          : [],
      isLiked: 0, // Xử lý null cho comments
    );
  }


}