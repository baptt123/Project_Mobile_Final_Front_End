
import 'package:flutter/material.dart';

import '../api/callingapi.dart';
import '../model/friend.dart';
import '../wigetforuser/profile.dart';

class FollowPageList extends StatefulWidget {
  final String currentUserId;

  FollowPageList({required this.currentUserId});

  @override
  _FollowPageState createState() => _FollowPageState();
}

class _FollowPageState extends State<FollowPageList> {
  late Future<List<Friend>> suggestedFriends;

  @override
  void initState() {
    super.initState();
    suggestedFriends = CallingAPI().fetchSuggestedFriends(widget.currentUserId);
  }

  Future<void> toggleFollow(Friend friend) async {
    try {
      if (friend.isFollowers) {
        await CallingAPI().unfollowUser(widget.currentUserId, friend.id);
        setState(() {
          friend.isFollowers = false;
        });
      } else {
        await CallingAPI().followUser(widget.currentUserId, friend.id);
        setState(() {
          friend.isFollowers = true;
        });
      }
    } catch (e) {
      print("Error in toggleFollow: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Gợi ý kết bạn"),
        centerTitle: true,
      ),
      body: FutureBuilder<List<Friend>>(
        future: suggestedFriends,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final friends = snapshot.data!;
            return ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileApp(userId: friend.id),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: friend.profileImagePath != null &&
                          friend.profileImagePath!.isNotEmpty
                          ? NetworkImage(friend.profileImagePath!)
                          : NetworkImage(
                          "https://nld.mediacdn.vn/2019/1/23/iron-man-15482507516511342859204.jpg"),
                    ),
                    title: Text(
                      friend.fullName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      overflow: TextOverflow.ellipsis, // Cắt tên nếu quá dài
                      maxLines: 1,
                    ),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: friend.isFollowers
                            ? Colors.grey
                            : Colors.blue,
                        padding:
                        EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: Size(60, 30), // Kích thước tối thiểu
                      ),
                      onPressed: () => toggleFollow(friend),
                      child: Text(
                        friend.isFollowers ? 'Unfollow' : 'Follow',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("Không có gợi ý nào"));
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FollowPageList(currentUserId: '6784b0cdc4f1d3341df6bce4'),
  ));
}
