


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import '../widgets/comments_bottom_sheet.dart';

class PostCard extends StatefulWidget {
  const PostCard({
    super.key,
    required this.post,
  });

  final Post post;

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late bool isLiked;
  late int likeCount;

  @override
  void initState() {
    super.initState();
    // Khởi tạo trạng thái từ dữ liệu ban đầu
    isLiked = widget.post.isLiked == 1;
    likeCount = widget.post.likeCount;
  }

  Future<void> _toggleLike() async {
    final newIsLiked = !isLiked;
    final newLikeCount = newIsLiked ? likeCount + 1 : likeCount - 1;

    setState(() {
      // Cập nhật tạm thời trên giao diện
      isLiked = newIsLiked;
      likeCount = newLikeCount;
    });

    try {
      // Gửi yêu cầu cập nhật trạng thái lên API
      final response = await http.put(
        Uri.parse('http://192.168.67.100:8080/api/post/get/takeLike/${widget.post.id}'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'isLike': newIsLiked ? 1 : 0}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update like status');
      }

      final updatedPost = json.decode(response.body);

      setState(() {
        isLiked = updatedPost['isLiked'] == 1;
        likeCount = updatedPost['likeCount'];
      });
    } catch (e) {
      // Nếu có lỗi, khôi phục trạng thái ban đầu
      setState(() {
        isLiked = !newIsLiked;
        likeCount = !newIsLiked ? likeCount + 1 : likeCount - 1;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final mobileCard = _mobileCard(context);
    final tabletCard = _tabletCard(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: MediaQuery.of(context).size.width < 600
          ? mobileCard
          : tabletCard,
    );
  }

  Widget _mobileCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundImage: AssetImage("assets/img/avt.jpg"),
          ),
          title: Text(
            widget.post.user.userName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            'Location here', // Nếu có trường location trong model, có thể thay thế
            style: textTheme.bodySmall,
          ),
          trailing: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Text(widget.post.caption),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: _postImage(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: _postButtons(),
        ),
      ],
    );
  }

  Widget _tabletCard(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: IntrinsicHeight(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: _postImage(),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                            // NetworkImage(widget.post.user.profileImagePath),
                            AssetImage("assets/img/avt.jpg")
                          ),
                          title: Text(
                            widget.post.user.userName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          subtitle: Text(
                            'Location here',
                            style: textTheme.bodySmall?.copyWith(
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: Text(widget.post.caption),
                        ),
                      ],
                    ),
                    _postButtons(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _postImage() {
    return Image.network(
      widget.post.media,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return const Center(child: Icon(Icons.broken_image, size: 48));
      },
    );
  }

  Widget _postButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : null,
          ),
          onPressed: _toggleLike,
          tooltip: "Like",
        ),
        Text('$likeCount likes'),
        IconButton(
          icon: const Icon(Icons.comment_outlined),
          onPressed: () {
            CommentsBottomSheet.showCommentsBottomSheet(context, post: widget.post);
          },
          tooltip: "Comment",
        ),
      ],
    );
  }
}
