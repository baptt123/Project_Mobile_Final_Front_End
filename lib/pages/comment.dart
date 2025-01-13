import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_social/models/models.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/v4.dart';

class CommentsBottomSheet {
  static Future<void> showCommentsBottomSheet(BuildContext context,
      {required Post post}) {
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
  User? currentUser; // Biến để lưu thông tin người dùng
  String? fullnameUser;
  @override
  void initState() {
    super.initState();
    _comments = widget.post.comments; // Dữ liệu các bình luận ban đầu
    _loadUser();
  }
  // Hàm để lấy thông tin người dùng từ GetStorage
  Future<void> _loadUser() async {
    final box = GetStorage();
    String? userJsonString = box.read('user');
    if (userJsonString != null) {
      // Giải mã JSON thành đối tượng User
      Map<String, dynamic> userJson = jsonDecode(userJsonString);
      setState(() {
        currentUser = User.fromJson(userJson);
        fullnameUser=currentUser?.fullName;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          _buildCommentList(),
          _buildInputField(context),
        ],
      ),
    );
  }

  Widget _buildCommentList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _comments.length,
        itemBuilder: (context, index) {
          final comment = _comments[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage('assets/img/avatar.jpg'),
            ),
            title: Text(
              comment.fullname,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(comment.text),
          );
        },
      ),
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
            IconButton(
              onPressed: () {
                if (_commentController.text.trim().isNotEmpty) {
                  setState(() {
                    _comments.add(
                      Comment(
                       id:Uuid().v4(),
                        fullname: fullnameUser!,
                        text: _commentController.text.trim()
                      ),
                    );
                  });
                  _commentController.clear();
                }
              },
              icon: const Icon(Icons.send),
              color: Theme.of(context).primaryColor,
            ),
          ],
        ),
      ),
    );
  }
}
