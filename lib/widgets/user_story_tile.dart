
import 'package:flutter/material.dart';

class UserStoryTile extends StatelessWidget {
  final String imageUrl; // Ảnh story
  final String username; // Tên người dùng
  final VoidCallback onTap; // Hành động khi nhấn vào story

  const UserStoryTile({
    super.key,
    required this.imageUrl,
    required this.username,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: GestureDetector(
            onTap: onTap,
            child: CircleAvatar(
              radius: 35,
              backgroundImage: NetworkImage(imageUrl), // Ảnh story
              backgroundColor: Colors.grey[200], // Màu nền nếu không có ảnh
            ),
          ),
        ),
        SizedBox(
          width: 75,
          child: Text(
            username,
            textAlign: TextAlign.center,
            style: textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.bold,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
