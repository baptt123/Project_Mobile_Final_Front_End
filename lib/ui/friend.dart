import 'package:flutter/material.dart';

import 'friends.dart';

class Friend {
  final int id;
  final String name;
  final String profileImageUrl;

  Friend({required this.id, required this.name, required this.profileImageUrl});
}

class FriendListPage extends StatefulWidget {
  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<FriendListPage> {
  List<Friend> allFriends = [];
  final int maxVisibleFriends = 6;

  @override
  void initState() {
    super.initState();
    fetchMockFriends();
  }

  Future<void> fetchMockFriends() async {
    await Future.delayed(Duration(seconds: 1));
    final friends = [

      Friend(id: 1, name: "Nguyễn Văn Nam", profileImageUrl: "https://tailieutienganh.edu.vn/public/files/upload/default/images/Captain-America-la-mot-sieu-anh-hung-hu-cau.jpg"),
      Friend(id: 2, name: "Trần Thị Ban", profileImageUrl: "https://i.pinimg.com/originals/ba/9f/f6/ba9ff63a91af6b27a62d933cc0e0842d.jpg"),
      Friend(id: 3, name: "Lê Văn Cup", profileImageUrl: "https://nld.mediacdn.vn/2019/1/23/iron-man-15482507516511342859204.jpg"),
      Friend(id: 4, name: "Phạm Thị Đạt", profileImageUrl: "https://genk.mediacdn.vn/2018/7/13/anh-2-15314588956971676081194.jpg"),
      Friend(id: 5, name: "Nguyễn Văn An Hồ Quang Hiếu", profileImageUrl: "https://tailieutienganh.edu.vn/public/files/upload/default/images/Captain-America-la-mot-sieu-anh-hung-hu-cau.jpg"),
      Friend(id: 6, name: "Trần Thị Bình", profileImageUrl: "https://i.pinimg.com/originals/ba/9f/f6/ba9ff63a91af6b27a62d933cc0e0842d.jpg"),
      Friend(id: 7, name: "Lê Văn Cồ", profileImageUrl: "https://nld.mediacdn.vn/2019/1/23/iron-man-15482507516511342859204.jpg"),
      Friend(id: 8, name: "Phạm Sinh", profileImageUrl: "https://genk.mediacdn.vn/2018/7/13/anh-2-15314588956971676081194.jpg"),
      Friend(id: 9, name: "Trần Bình", profileImageUrl: "https://i.pinimg.com/originals/ba/9f/f6/ba9ff63a91af6b27a62d933cc0e0842d.jpg"),
      Friend(id: 10, name: "Lê Cồ", profileImageUrl: "https://nld.mediacdn.vn/2019/1/23/iron-man-15482507516511342859204.jpg"),
      Friend(id: 11, name: "Phạm Thị Sinh", profileImageUrl: "https://genk.mediacdn.vn/2018/7/13/anh-2-15314588956971676081194.jpg"),
    ];
    setState(() {
      allFriends = friends;
    });
  }

  void navigateToAllFriendsPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AllFriendListPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleFriends =
    allFriends.take(maxVisibleFriends).toList(); // Lấy tối đa 6 người
    return Scaffold(
      appBar: AppBar(
        title: Text("Bạn bè"),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Số cột
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 2 / 2.2, // Tỷ lệ khung hình
              ),
              itemCount: visibleFriends.length,
              itemBuilder: (context, index) {
                final friend = visibleFriends[index];
                return Card(
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            friend.profileImageUrl,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          friend.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          // maxLines: 2,
                          overflow: TextOverflow.ellipsis, // nếu dài quá  thì hiển thị '...'
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: ElevatedButton(
              onPressed: navigateToAllFriendsPage,
              child: Text("Xem tất cả bạn bè"),
            ),
          ),
        ],
      ),
    );
  }
}
void main() {
  runApp(MaterialApp(
    home: FriendListPage(),
  ));
}
