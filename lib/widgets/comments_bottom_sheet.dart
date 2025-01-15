import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_social/models/models.dart';
import 'package:uuid/uuid.dart';

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

Future<void> submitComment({
  required String postId,
  required String id,
  required String fullName,
  required String text,
}) async {
  try {
    final url = Uri.parse('http://192.168.1.95:8080/api/post/get/${postId}/comments');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': id,
        'fullName': fullName, // Lấy fullname từ người dùng hiện tại
        'text': text,
      }),
    );

    if (response.statusCode == 200) {
      print('Comment added successfully!');
    } else {
      throw Exception('Failed to add comment: ${response.body}');
    }
  } catch (e) {
    print('Error while adding comment: $e');
    rethrow; // Ném lỗi lại để xử lý ở nơi gọi hàm
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
  User? currentUser; // Biến để lưu thông tin người dùng hiện tại
  bool _isSubmitting = false; // Trạng thái gửi bình luận

  @override
  void initState() {
    super.initState();
    _comments = widget.post.comments; // Lấy danh sách bình luận ban đầu
    _loadUser();
  }

  /// Hàm để lấy thông tin người dùng từ GetStorage
  Future<void> _loadUser() async {
    final box = GetStorage();
    String? userJsonString = box.read('user');
    if (userJsonString != null) {
      // Giải mã JSON thành đối tượng User
      Map<String, dynamic> userJson = jsonDecode(userJsonString);
      setState(() {
        currentUser = User.fromJson(userJson); // Lưu thông tin người dùng hiện tại
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
                ? const CircularProgressIndicator()
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
      final commentId = Uuid().v4();
      final fullname = currentUser!.fullName; // Lấy fullname từ người dùng hiện tại
      final text = _commentController.text.trim();

      // Gửi bình luận qua API
      await submitComment(
        postId: widget.post.id,
        id: commentId,
        fullName: fullname,
        text: text,
      );

      // Cập nhật danh sách bình luận
      setState(() {
        _comments.add(
          Comment(id: commentId, fullName: fullname, text: text),
        );
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
