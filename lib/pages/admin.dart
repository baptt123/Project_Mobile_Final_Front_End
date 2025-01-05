// Màn hình chính với TabView
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quick_social/api/callingapi.dart';

import '../dto/postdto.dart';
import '../dto/userdto.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

// Widget HomeScreen
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Panel'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Người dùng'),
            Tab(text: 'Bài viết'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          UserList(),  // Danh sách người dùng
          PostList(),  // Danh sách bài viết
        ],
      ),
    );
  }
}

// Hiển thị danh sách người dùng
class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  late Future<List<UserDTO>> _users;

  @override
  void initState() {
    super.initState();
    _users = CallingAPI.fetchUsersAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UserDTO>>(
      future: _users,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Lỗi: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có người dùng'));
        }

        final users = snapshot.data!;
        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                // Kiểm tra null cho profileImagePath trước khi sử dụng
                backgroundImage: user.profileImagePath != null
                    ? NetworkImage(user.profileImagePath!) // Dùng dấu "!" để chắc chắn là không null
                    : NetworkImage('https://via.placeholder.com/150'), // Placeholder khi null
              ),
              title: Text(user.fullName ?? 'Chưa có tên'), // Hiển thị "Chưa có tên" nếu fullName là null
              subtitle: Text('Giới tính: ${user.gender == 1 ? 'Nam' : 'Nữ'}'),
            );
          },
        );
      },
    );
  }
}



// Hiển thị danh sách bài viết
class PostList extends StatefulWidget {
  @override
  _PostListState createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  late Future<List<PostDTO>> _posts;

  @override
  void initState() {
    super.initState();
    _posts = CallingAPI.fetchPostsAdmin();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PostDTO>>(
      future: _posts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Không có bài viết'));
        }

        final posts = snapshot.data!;
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return ListTile(
              title: Text(post.caption),
              // subtitle: Text('Người đăng: ${post.user.fullName}'),
              leading: Image.network(post.media, width: 50, height: 50, fit: BoxFit.cover),
            );
          },
        );
      },
    );
  }
}