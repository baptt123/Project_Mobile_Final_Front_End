import '../models/userinfo.dart';

class PostDTO {
  final String caption;
  final String media;
  final UserInfo user;

  PostDTO({
    required this.caption,
    required this.media,
    required this.user,
  });

  factory PostDTO.fromJson(Map<String, dynamic> json) {
    return PostDTO(
      caption: json['caption'] ?? '',
      media: json['media'] ?? '',
      user: UserInfo.fromJson(json['user'] ?? {}),
    );
  }
}