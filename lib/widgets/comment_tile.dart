import 'package:flutter/material.dart';
import 'package:quick_social/models/models.dart';

class CommentTile extends StatelessWidget {
  const CommentTile({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Default avatar image
          const CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage('assets/img/default_avatar.png'),
          ),
          const SizedBox(width: 8),
          // Comment content
          Flexible(
            child: Card(
              margin: EdgeInsets.zero,
              elevation: 1,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // User name
                    Text(
                      comment.fullName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Comment text
                    Text(
                      comment.text,
                      style: theme.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    // Like button
                    Row(
                      children: const [
                        _CommentLikeButton(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CommentLikeButton extends StatefulWidget {
  const _CommentLikeButton({super.key});

  @override
  State<_CommentLikeButton> createState() => _CommentLikeButtonState();
}

class _CommentLikeButtonState extends State<_CommentLikeButton> {
  bool _isLiked = false;
  int _likeCount = 0;

  @override
  void initState() {
    super.initState();
    _likeCount = 0; // Random like count
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: () {
        setState(() {
          _isLiked = !_isLiked;
          _isLiked ? _likeCount++ : _likeCount--;
        });
      },
      child: Row(
        children: [
          Icon(
            _isLiked ? Icons.favorite : Icons.favorite_outline,
            color: _isLiked ? theme.colorScheme.primary : theme.iconTheme.color,
            size: 18,
          ),
          const SizedBox(width: 4),
          Text(
            _likeCount.toString(),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
