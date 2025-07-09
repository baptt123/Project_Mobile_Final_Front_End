import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_social/models/models.dart';
import 'package:uuid/uuid.dart';
import '../api/callingapi.dart';

class CommentsBottomSheet {
  static Future<void> showCommentsBottomSheet(BuildContext context, {required Post post}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CommentSection(post: post),
    );
  }
}

class _CommentSection extends StatefulWidget {
  const _CommentSection({Key? key, required this.post}) : super(key: key);

  final Post post;

  @override
  State<_CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<_CommentSection> {
  final TextEditingController _commentController = TextEditingController();
  late List<Comment> _comments;
  User? currentUser;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _comments = widget.post.comments;
    _loadUser();
  }

  Future<void> _loadUser() async {
    final box = GetStorage();
    String? userJsonString = box.read('user');
    if (userJsonString != null) {
      Map<String, dynamic> userJson = jsonDecode(userJsonString);
      setState(() {
        currentUser = User.fromJson(userJson);
      });
    } else {
      print("No user found in GetStorage.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Expanded(child: _buildCommentList()),
          _buildInputField(context),
        ],
      ),
    );
  }

  Widget _buildCommentList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _comments.length,
      itemBuilder: (context, index) {
        final comment = _comments[index];
        return ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/img/avatar.jpg'),
          ),
          title: Text(
            comment.fullName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(comment.text),
        );
      },
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Container(
        color: Colors.grey[100],
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _commentController,
                decoration: const InputDecoration(
                  hintText: "Write a comment...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                ),
              ),
            ),
            const SizedBox(width: 8),
            _isSubmitting
                ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
                : IconButton(
              onPressed: _submitComment,
              icon: const Icon(Icons.send),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitComment() async {
    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comment cannot be empty')),
      );
      return;
    }

    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User not logged in')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final commentId = const Uuid().v4();
      final fullName = currentUser!.fullName;
      final text = _commentController.text.trim();

      // ⬇ Gọi API đúng từ service đã tạo
      await CallingAPIService.submitComment(
        postId: widget.post.id,
        id: commentId,
        fullName: fullName,
        text: text,
      );

      setState(() {
        _comments.add(Comment(id: commentId, fullName: fullName, text: text));
        _commentController.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit comment: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }
}
