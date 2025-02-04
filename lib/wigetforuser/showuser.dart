import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import '../models/user.dart';

class ShowUser extends StatefulWidget {
  @override
  _ShowUserScreen createState() => _ShowUserScreen();
}

class _ShowUserScreen extends State<ShowUser> {
  User? currentUser; // Biến để lưu thông tin người dùng

  @override
  void initState() {
    super.initState();
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
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kiểm tra nếu dữ liệu người dùng chưa được tải
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Thông tin người dùng'),
        ),
        body: Center(
          child: CircularProgressIndicator(), // Hiển thị loading nếu chưa có dữ liệu
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Thông tin người dùng'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text(currentUser!.id.substring(0, 1)), // Hiển thị chữ cái đầu tiên của ID
            ),
            title: Text(currentUser!.username),
            subtitle: Text('Email: ${currentUser!.email}\nFull Name: ${currentUser!.fullName}\nID: ${currentUser!.id}'),
          ),
          Divider(), // Thêm một divider để tách các mục
          ListTile(
            title: Text('Gender: ${currentUser!.gender == 0 ? "Male" : "Female"}'),
          ),
          ListTile(
            title: Text('Followers Count: ${currentUser!.followersCount}'),
          ),
          ListTile(
            title: Text('Following Count: ${currentUser!.followingCount}'),
          ),
          ListTile(
            title: Text('Status: ${currentUser!.status == 1 ? "Online" : "Offline"}'),
          ),
          ListTile(
            title: Text('Profile Image Path: ${currentUser!.profileImagePath}'),
          ),
          ListTile(
            title: Text('Friends: ${currentUser!.friends.join(', ')}'), // Hiển thị danh sách bạn bè
          ),
          ListTile(
            title: Text('Posts Saved: ${currentUser!.postsSaved.join(', ')}'), // Hiển thị danh sách bài viết đã lưu
          ),
          ListTile(
            title: Text('Posts Shared: ${currentUser!.postsShared.join(', ')}'), // Hiển thị danh sách bài viết đã chia sẻ
          ),
        ],
      ),
    );

  }
}
