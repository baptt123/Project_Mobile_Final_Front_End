// import 'package:flutter/material.dart';
//
// import 'FollowPage.dart';
//
// // Class Friend để quản lý thông tin bạn bè
// // class Friend {
// //   final int id;
// //   final String name;
// //   final String profileImageUrl;
// //   bool isFollowing;
// //
// //   Friend({
// //     required this.id,
// //     required this.name,
// //     required this.profileImageUrl,
// //     this.isFollowing = false,
// //   });
// // }
// List<Friend> getMockFriends() {
//   return [
//     Friend(
//       id: '1',
//       name: "Nguyễn Văn Nam",
//       profileImageUrl: "https://i.pinimg.com/originals/ba/9f/f6/ba9ff63a91af6b27a62d933cc0e0842d.jpg",
//     ),
//     Friend(
//       id: '2',
//       name: "Trần Thị Hoa",
//       profileImageUrl: "https://i.pinimg.com/originals/ba/9f/f6/ba9ff63a91af6b27a62d933cc0e0842d.jpg",
//     ),
//     Friend(
//       id: '3',
//       name: "Lê Minh Huy",
//       profileImageUrl: "https://i.pinimg.com/originals/ba/9f/f6/ba9ff63a91af6b27a62d933cc0e0842d.jpg",
//     ),
//     Friend(
//       id: '4',
//       name: "Phạm Thị Đạt",
//       profileImageUrl: "https://i.pinimg.com/originals/ba/9f/f6/ba9ff63a91af6b27a62d933cc0e0842d.jpg",
//     ),
//   ];
// }
//
// // FollowPage để hiển thị danh sách bạn bè với chức năng Follow/Unfollow
// class FollowPage extends StatefulWidget {
//   final List<Friend> allFriends;
//
//   FollowPage({required this.allFriends});
//
//   @override
//   _FollowPageState createState() => _FollowPageState();
// }
//
// class _FollowPageState extends State<FollowPage> {
//   late List<Friend> friends;
//
//   @override
//   void initState() {
//     super.initState();
//     friends = widget.allFriends; // Lấy danh sách bạn bè từ tham số
//   }
//
//   void toggleFollow(Friend friend) {
//     setState(() {
//       friend.isFollowing =
//       !friend.isFollowing; // Đảo trạng thái Follow/Unfollow
//     });
//   }
//
//   void removeFriend(Friend friend) {
//     setState(() {
//       friends.remove(friend); // Xóa người bạn khỏi danh sách
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Danh sách chưa kết bạn"),
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: GridView.builder(
//               padding: EdgeInsets.all(10),
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2, // Số cột trong GridView
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 childAspectRatio: 2 / 3, // Tỉ lệ khung hình của mỗi ô
//               ),
//               itemCount: friends.length,
//               itemBuilder: (context, index) {
//                 final friend = friends[index];
//                 return Card(
//                   elevation: 4,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Expanded(
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.network(
//                             friend.profileImageUrl,
//                             fit: BoxFit.cover,
//                             width: double.infinity,
//                           ),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Text(
//                           friend.name,
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 14,
//                           ),
//                           textAlign: TextAlign.center,
//                         ),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         children: [
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: friend.isFollowing
//                                   ? Colors.grey
//                                   : Colors.blue,
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 4),
//                               minimumSize: Size(50, 30),
//                               textStyle: TextStyle(fontSize: 12),
//                             ),
//                             onPressed: () => toggleFollow(friend),
//                             child: Text(
//                                 friend.isFollowing ? 'Hủy bạn' : 'Kết bạn'),
//                           ),
//                           ElevatedButton(
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Colors.red,
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 8, vertical: 4),
//                               minimumSize: Size(50, 30),
//                               textStyle: TextStyle(fontSize: 12),
//                             ),
//                             onPressed: () => removeFriend(friend),
//                             child: Text("Gỡ"),
//                           ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//           // Padding(
//           //   padding: const EdgeInsets.all(8.0),
//           //   child: ElevatedButton(
//           //     style: ElevatedButton.styleFrom(
//           //       padding: EdgeInsets.symmetric(vertical: 12, horizontal: 20),
//           //       textStyle: TextStyle(fontSize: 16),
//           //     ),
//           //     // onPressed: () {
//           //     //   // Hành động khi nhấn nút "Xem tất cả"
//           //     //   Navigator.push(
//           //     //     context,
//           //     //     MaterialPageRoute(
//           //     //       builder: (context) => FollowPageList(allFriends: getMockFriends()),
//           //     //     ),
//           //     //   );
//           //     // },
//           //     child: Text("Xem tất cả"),
//           //   ),
//           // ),
//         ],
//       ),
//     );
//   }
// }
//
// // Hàm main khởi động ứng dụng Flutter
//   void main() {
//     // Tạo danh sách bạn bè mẫu
//     final mockFriends = getMockFriends();
//
//     // Chạy ứng dụng
//     runApp(
//       MaterialApp(
//         debugShowCheckedModeBanner: false,
//         title: 'Follow Demo',
//         theme: ThemeData(primarySwatch: Colors.blue),
//         home: FollowPage(allFriends: mockFriends),
//       ),
//     );
//   }
//
