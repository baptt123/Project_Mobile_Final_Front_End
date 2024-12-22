import 'package:flutter/material.dart';

class Friend {
  final int id;
  final String name;
  final String profileImageUrl;

  Friend({required this.id, required this.name, required this.profileImageUrl});
}

class AllFriendListPage extends StatefulWidget {
  @override
  _FriendListPageState createState() => _FriendListPageState();
}

class _FriendListPageState extends State<AllFriendListPage> {
  List<Friend> allFriends = [];
  List<Friend> filteredFriends = [];
  TextEditingController searchController = TextEditingController();

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
      Friend(id: 5, name: "Nguyễn Văn An", profileImageUrl: "https://tailieutienganh.edu.vn/public/files/upload/default/images/Captain-America-la-mot-sieu-anh-hung-hu-cau.jpg"),
      Friend(id: 6, name: "Trần Thị Bình", profileImageUrl: "https://i.pinimg.com/originals/ba/9f/f6/ba9ff63a91af6b27a62d933cc0e0842d.jpg"),
      Friend(id: 7, name: "Lê Văn Cồ", profileImageUrl: "https://nld.mediacdn.vn/2019/1/23/iron-man-15482507516511342859204.jpg"),
      Friend(id: 8, name: "Phạm Sinh", profileImageUrl: "https://genk.mediacdn.vn/2018/7/13/anh-2-15314588956971676081194.jpg"),
      Friend(id: 9, name: "Trần Bình", profileImageUrl: "https://i.pinimg.com/originals/ba/9f/f6/ba9ff63a91af6b27a62d933cc0e0842d.jpg"),
      Friend(id: 10, name: "Lê Cồ", profileImageUrl: "https://nld.mediacdn.vn/2019/1/23/iron-man-15482507516511342859204.jpg"),
      Friend(id: 11, name: "Phạm Thị Sinh", profileImageUrl: "https://genk.mediacdn.vn/2018/7/13/anh-2-15314588956971676081194.jpg"),
    ];
    setState(() {
      allFriends = friends;
      filteredFriends = friends;
    });
  }

  void filterFriends(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        filteredFriends = allFriends;
      } else {
        filteredFriends = allFriends
            .where((friend) => friend.name.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }

  void handleMenuAction(Friend friend, String action) {
    setState(() {
      if (action == "favorite") {
        print("Yêu thích ${friend.name}");
        // Xử lý yêu thích
      } else if (action == "edit") {
        print("Chỉnh sửa danh sách bạn bè của ${friend.name}");
        // Xử lý chỉnh sửa danh sách bạn bè
      } else if (action == "unfollow") {
        print("Bỏ theo dõi ${friend.name}");
        // Xử lý bỏ theo dõi
      } else if (action == "unfriend") {
        print("Hủy kết bạn với ${friend.name}");
        allFriends.remove(friend);
        filteredFriends.remove(friend); // Cập nhật danh sách hiển thị
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh sách bạn bè"),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: "Tìm kiếm bạn bè...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                filterFriends(value);
              },
            ),
          ),
          Expanded(
            child: filteredFriends.isEmpty
                ? Center(child: Text("Không tìm thấy bạn bè nào."))
                : ListView.builder(
              itemCount: filteredFriends.length,
              itemBuilder: (context, index) {
                final friend = filteredFriends[index];
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(friend.profileImageUrl),
                    ),
                    title: Text(friend.name),
                    trailing: PopupMenuButton<String>(
                      onSelected: (action) => handleMenuAction(friend, action),
                      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: "favorite",
                          child: Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow),
                              SizedBox(width: 10),
                              Text("Yêu thích"),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: "edit",
                          child: Row(
                            children: [
                              Icon(Icons.edit, color: Colors.blue),
                              SizedBox(width: 10),
                              Text("Chỉnh sửa danh sách bạn bè"),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: "unfollow",
                          child: Row(
                            children: [
                              Icon(Icons.remove_circle, color: Colors.orange),
                              SizedBox(width: 10),
                              Text("Bỏ theo dõi"),
                            ],
                          ),
                        ),
                        PopupMenuItem<String>(
                          value: "unfriend",
                          child: Row(
                            children: [
                              Icon(Icons.person_remove, color: Colors.red),
                              SizedBox(width: 10),
                              Text("Hủy kết bạn"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AllFriendListPage(),
  ));
}
