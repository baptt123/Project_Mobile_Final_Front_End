import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_social/ui/testchatui.dart';
import '../api/callingapi.dart';
import '../model/friend.dart';
import 'dart:convert';

import '../wigetforuser/profile.dart';

class FriendsFollowingScreen extends StatefulWidget {
  final String userId;

  const FriendsFollowingScreen({required this.userId, Key? key}) : super(key: key);

  @override
  _FriendsFollowingScreenState createState() => _FriendsFollowingScreenState();
}

class _FriendsFollowingScreenState extends State<FriendsFollowingScreen> {
  late Future<List<Friend>> followingFuture;
  late Future<List<Friend>> friendsFuture;
  final GetStorage _storage = GetStorage();
  // Ví dụ: Danh sách bạn bè (có thể lấy từ API)
  List<Map<String, String>> friendsList = [
    {'fullName': 'John Doe', 'userId': '123'},
    {'fullName': 'Jane Smith', 'userId': '456'},
  ];

  // Hàm để chuyển trang chat và lưu dữ liệu trước
  void _startChat(String fullName) {
    // Lưu fullName vào GetStorage
    _storage.write('selectedUser', fullName);

    // Chuyển sang màn hình ChatScreen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ChatScreen()),
    );
  }


  @override
  void initState() {
    super.initState();
    followingFuture = CallingAPI().fetchFollowing(widget.userId);
    friendsFuture = CallingAPI().fetchFriends(widget.userId);
  }

  Future<void> toggleFriendStatus(Friend friend) async {
    try {
      if (friend.isFriend) {
        await CallingAPI().unfollowUser(widget.userId, friend.id);
        setState(() {
          friend.isFriend = false;
          friend.isFollowing = true;
        });
      } else {
        await CallingAPI().followUser(widget.userId, friend.id);
        setState(() {
          friend.isFriend = true;
          friend.isFollowing = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Lỗi: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> toggleFollowStatus(Friend friend) async {
    try {
      if (friend.isFollowing) {
        await CallingAPI().unfollowUser(widget.userId, friend.id);
        setState(() {
          friend.isFollowing = false;
        });
      } else {
        await CallingAPI().followUser(widget.userId, friend.id);
        setState(() {
          friend.isFollowing = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Lỗi: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }
  Widget buildFriendTile(Friend friend, {required bool isFriendsTab}) {
    if (isFriendsTab) {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: friend.profileImagePath != null && friend.profileImagePath!.isNotEmpty
                    ? NetworkImage(friend.profileImagePath!)
                    : const NetworkImage("https://nld.mediacdn.vn/2019/1/23/iron-man-15482507516511342859204.jpg"),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),

                    ),
                    const SizedBox(height: 4),
                    Text(
                      friend.fullName,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => _startChat(friend.fullName),
                    child: const Text(
                      "Nhắn tin",
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: friend.isFriend ? Colors.grey[300]! : Colors.blue,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    onPressed: () => toggleFriendStatus(friend),
                    child: Text(
                      friend.isFriend ? "Bạn bè" : "Follow lại",
                      style: TextStyle(
                        color: friend.isFriend ? Colors.black : Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    } else {
      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: friend.profileImagePath != null && friend.profileImagePath!.isNotEmpty
                    ? NetworkImage(friend.profileImagePath!)
                    : const NetworkImage("https://nld.mediacdn.vn/2019/1/23/iron-man-15482507516511342859204.jpg"),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      friend.fullName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      friend.fullName,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: friend.isFollowing ? Colors.grey[300]! : Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () => toggleFollowStatus(friend),
                child: Text(
                  friend.isFollowing ? "Đang follow" : "Follow",
                  style: TextStyle(
                    color: friend.isFollowing ? Colors.black : Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget buildEmptyMessage(String message) {
    return Center(
      child: Text(
        message,
        style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
      ),
    );
  }

  Widget buildFriendsTab(List<Friend> friends) {
    if (friends.isEmpty) {
      return buildEmptyMessage("Không có bạn bè.");
    }

    return ListView(
      children: friends.map((friend) => buildFriendTile(friend, isFriendsTab: true)).toList(),
    );
  }

  Widget buildFollowingTab(List<Friend> following) {
    if (following.isEmpty) {
      return buildEmptyMessage("Không có người theo dõi.");
    }

    return ListView(
      children: following.map((friend) => buildFriendTile(friend, isFriendsTab: false)).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Danh sách bạn bè và theo dõi'),
          backgroundColor: Colors.blueAccent,
          bottom: const TabBar(
            tabs: [
              Tab(text: "Bạn bè"),
              Tab(text: "Đang theo dõi"),
            ],
          ),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: Future.wait([friendsFuture, followingFuture]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Lỗi: ${snapshot.error}',
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else if (!snapshot.hasData || snapshot.data == null) {
              return buildEmptyMessage("Không có dữ liệu.");
            }

            final friends = snapshot.data![0] as List<Friend>;
            final following = snapshot.data![1] as List<Friend>;

            return TabBarView(
              children: [
                buildFriendsTab(friends),
                buildFollowingTab(following),
              ],
            );
          },
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primarySwatch: Colors.blue),
    home: FriendsFollowingScreen(userId: '6784b0cdc4f1d3341df6bce4'),
  ));
}
