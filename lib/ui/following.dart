import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quick_social/ui/testchatui.dart';
import '../api/callingapi.dart';
import '../model/friend.dart';
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

  // void sendMessage(Friend friend) {
  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //     content: Text("Nhắn tin với ${friend.fullName}"),
  //     backgroundColor: Colors.green,
  //   ));
  // }

  Widget buildFriendTile(Friend friend, {required bool isFriendsTab}) {
    if (isFriendsTab) {
      return ListTile(
        // chuyển hướng
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileApp(userId: friend.id),
            ),
          );
        },
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: friend.profileImagePath != null && friend.profileImagePath!.isNotEmpty
              ? NetworkImage(friend.profileImagePath!)
              : const NetworkImage("https://nld.mediacdn.vn/2019/1/23/iron-man-15482507516511342859204.jpg"),
        ),
        title: Text(
          friend.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          friend.fullName,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        trailing: Row(
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
            const SizedBox(width: 8),
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
      );
    } else {
      return ListTile(
        // chuyển hướng
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileApp(userId: friend.id),
            ),
          );
        },
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: friend.profileImagePath != null && friend.profileImagePath!.isNotEmpty
              ? NetworkImage(friend.profileImagePath!)
              : const NetworkImage("https://nld.mediacdn.vn/2019/1/23/iron-man-15482507516511342859204.jpg"),
        ),
        title: Text(
          friend.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(
          friend.fullName,
          style: const TextStyle(color: Colors.grey, fontSize: 14),
        ),
        trailing: ElevatedButton(
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

// import 'package:flutter/material.dart';
// import '../api/callingapi.dart';
// import '../model/friend.dart';
//
// class FriendsFollowingScreen extends StatefulWidget {
//   final String userId;
//
//   const FriendsFollowingScreen({required this.userId, Key? key}) : super(key: key);
//
//   @override
//   _FriendsFollowingScreenState createState() => _FriendsFollowingScreenState();
// }
//
// class _FriendsFollowingScreenState extends State<FriendsFollowingScreen> {
//   late Future<List<Friend>> followingFuture;
//   late Future<List<Friend>> friendsFuture;
//
//   @override
//   void initState() {
//     super.initState();
//     followingFuture = CallingAPI().fetchFollowing(widget.userId);
//     friendsFuture = CallingAPI().fetchFriends(widget.userId);
//   }
//
//   Future<void> toggleFriendStatus(Friend friend) async {
//     try {
//       if (friend.isFriend) {
//         // Unfriend: Xóa khỏi danh sách bạn bè và chuyển thành người theo dõi
//         await CallingAPI().unfollowUser(widget.userId, friend.id); // Hủy bạn bè
//         setState(() {
//           friend.isFriend = false;
//           friend.isFollowing = true; // Chuyển sang trạng thái người theo dõi
//         });
//       } else {
//         // Follow lại: Chuyển từ trạng thái "theo dõi" thành "bạn bè"
//         await CallingAPI().followUser(widget.userId, friend.id); // Thêm vào danh sách bạn bè
//         setState(() {
//           friend.isFriend = true;  // Trở thành bạn bè
//           friend.isFollowing = false; // Xóa khỏi danh sách người theo dõi
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Lỗi: $e"),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }
//
//   Future<void> toggleFollowStatus(Friend friend) async {
//     try {
//       if (friend.isFollowing) {
//         // Unfollow: Xóa khỏi danh sách theo dõi
//         await CallingAPI().unfollowUser(widget.userId, friend.id); // Hủy theo dõi
//         setState(() {
//           friend.isFollowing = false;  // Đánh dấu là không còn theo dõi
//         });
//       } else {
//         // Follow lại: Thêm vào danh sách theo dõi
//         await CallingAPI().followUser(widget.userId, friend.id); // Thêm vào danh sách theo dõi
//         setState(() {
//           friend.isFollowing = true;  // Trở thành người theo dõi
//         });
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text("Lỗi: $e"),
//         backgroundColor: Colors.red,
//       ));
//     }
//   }
//
//   Widget buildFriendTile(Friend friend, {required bool isFriendsTab}) {
//     String buttonText;
//     Color buttonColor;
//     VoidCallback? onPressed;
//
//     if (isFriendsTab) {
//       buttonText = friend.isFriend ? "Bạn bè" : "Follow lại" ;
//       buttonColor = friend.isFriend ? Colors.grey[300]! : Colors.blue;
//       onPressed = () => toggleFriendStatus(friend);
//     } else {
//       buttonText = friend.isFollowing ?  "Đang follow" : "Follow" ;
//       buttonColor = friend.isFollowing ? Colors.grey[300]! : Colors.blue;
//       onPressed = () => toggleFollowStatus(friend);
//     }
//
//     return ListTile(
//       contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       leading: CircleAvatar(
//         radius: 30,
//         backgroundImage: friend.profileImagePath != null && friend.profileImagePath!.isNotEmpty
//             ? NetworkImage(friend.profileImagePath!)
//             : const NetworkImage("https://nld.mediacdn.vn/2019/1/23/iron-man-15482507516511342859204.jpg"),
//       ),
//       title: Text(
//         friend.fullName,
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//       ),
//       subtitle: Text(
//         friend.fullName,
//         style: const TextStyle(color: Colors.grey, fontSize: 14),
//       ),
//       trailing: ElevatedButton(
//         style: ElevatedButton.styleFrom(
//           backgroundColor: buttonColor,
//           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(20),
//           ),
//         ),
//         onPressed: onPressed,
//         child: Text(
//           buttonText,
//           style: TextStyle(
//             color: buttonColor == Colors.blue ? Colors.white : Colors.black,
//             fontSize: 14,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildEmptyMessage(String message) {
//     return Center(
//       child: Text(
//         message,
//         style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
//       ),
//     );
//   }
//
//   Widget buildFriendsTab(List<Friend> friends) {
//     if (friends.isEmpty) {
//       return buildEmptyMessage("Không có bạn bè.");
//     }
//
//     return ListView(
//       children: friends.map((friend) => buildFriendTile(friend, isFriendsTab: true)).toList(),
//     );
//   }
//
//   Widget buildFollowingTab(List<Friend> following) {
//     if (following.isEmpty) {
//       return buildEmptyMessage("Không có người theo dõi.");
//     }
//
//     return ListView(
//       children: following.map((friend) => buildFriendTile(friend, isFriendsTab: false)).toList(),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 2,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('Danh sách bạn bè và theo dõi'),
//           backgroundColor: Colors.blueAccent,
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: "Bạn bè"),
//               Tab(text: "Đang theo dõi"),
//             ],
//           ),
//         ),
//         body: FutureBuilder<List<dynamic>>(
//           future: Future.wait([friendsFuture, followingFuture]),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(
//                 child: Text(
//                   'Lỗi: ${snapshot.error}',
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               );
//             } else if (!snapshot.hasData || snapshot.data == null) {
//               return buildEmptyMessage("Không có dữ liệu.");
//             }
//
//             final friends = snapshot.data![0] as List<Friend>;
//             final following = snapshot.data![1] as List<Friend>;
//
//             return TabBarView(
//               children: [
//                 buildFriendsTab(friends),
//                 buildFollowingTab(following),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
//
// void main() {
//   runApp(MaterialApp(
//     debugShowCheckedModeBanner: false,
//     theme: ThemeData(primarySwatch: Colors.blue),
//     home: FriendsFollowingScreen(userId: '6784b0cdc4f1d3341df6bce4'),
//   ));
// }
