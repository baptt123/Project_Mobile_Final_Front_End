import 'package:app_chat/calling_api/CallingAPI.dart';
import 'package:flutter/material.dart';

// import 'package:app_chat/calling_api/CallingAPI.dart';

import 'package:app_chat/model/friend.dart';

// Widget FollowPage để hiển thị danh sách bạn bè
class FollowPageList extends StatefulWidget {
  final List<Friend> allFriends;
  final String currentUserId; // ID của người dùng hiện tại

  FollowPageList({
    required this.allFriends,
    required this.currentUserId,
  });

  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPageList> {
  late List<Friend> friends;

  @override
  void initState() {
    super.initState();
    friends = widget.allFriends;
  }

  void toggleFollow(Friend friend) async {
    if (friend.isFollowing) {
      // Hủy kết bạn
      final success = await CallingAPI.unfollowUser(widget.currentUserId, friend.id);
      if (success) {
        setState(() {
          friend.isFollowing = false;
        });
      } else {
        _showError("Hủy kết bạn thất bại!");
      }
    } else {
      // Kết bạn
      final success = await CallingAPI.followUser(widget.currentUserId, friend.id);
      if (success) {
        setState(() {
          friend.isFollowing = true;
        });
      } else {
        _showError("Kết bạn thất bại!");
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách bạn bè chưa follow"),
      ),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          final friend = friends[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: ListTile(
              leading: CircleAvatar(
                backgroundImage: NetworkImage(friend.profileImageUrl ??''),
              ),
              title: Text(friend.name),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: friend.isFollowing ? Colors.grey : Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size(50, 30),
                ),
                onPressed: () => toggleFollow(friend),
                child: Text(friend.isFollowing ? 'Hủy kết bạn' : 'Kết bạn'),
              ),
            ),
          );
        },
      ),
    );
  }
}

// void main() {
//   // Tạo danh sách bạn bè mẫu
//   final mockFriends = [
//     Friend(
//       id: 1,
//       name: "Nguyễn Văn Nam",
//       profileImageUrl: "https://i.pinimg.com/originals/ba/9f/f6/ba9ff63a91af6b27a62d933cc0e0842d.jpg",
//     ),
//     Friend(
//       id: 2,
//       name: "Trần Thị Hoa",
//       profileImageUrl: "https://i.pinimg.com/originals/ba/9f/f6/ba9ff63a91af6b27a62d933cc0e0842d.jpg",
//     ),
//   ];
//
//   final callingAPI = CallingAPI(baseUrl: 'http://localhost:8080'); // Backend API URL
//
//   runApp(
//     MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Follow Demo',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: FollowPageList(
//         allFriends: mockFriends,
//         currentUserId: 1001, // ID của người dùng hiện tại
//         callingAPI: callingAPI,
//       ),
//     ),
//   );
// }
