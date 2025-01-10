import 'package:flutter/material.dart';
import 'package:quick_social/calling_api/callingapi.dart';

import '../model/friend.dart';

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
    suggestedFriends =  CallingAPIFriends().fetchSuggestedFriends(widget.currentUserId);
  }
  // Future<void> fetchAndSetSuggestedFriends(String userId) async {
  //   final suggestedFriends = await CallingAPI().fetchSuggestedFriends(userId);
  //   setState(() {
  //     suggestedFriends = suggestedFriends; // Cập nhật _suggestedFriends nếu có biến này
  //   });
  // }
  Future<void> toggleFollow(Friend friend) async {
    try {
      if (friend.isFollowing) {
        // Call API to unfollow
        await CallingAPIFriends().unfollowUser(widget.currentUserId, friend.id);
        setState(() {
          friend.isFollowing = false;
        });
      } else {
        // Call API to follow
        await CallingAPIFriends().followUser(widget.currentUserId, friend.id);
        setState(() {
          friend.isFollowing = true;
        });
      }
    } catch (e) {
      print("Error in toggleFollow: $e");
      // Handle error (e.g., show a Snackbar)
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
              itemCount: friends.length,
              itemBuilder: (context, index) {
                final friend = friends[index];
                return ListTile(
                  leading: CircleAvatar(
                    // backgroundImage: NetworkImage(friend.profileImageUrl ?? ''),
                    backgroundImage: friend.profileImagePath != null && friend.profileImagePath!.isNotEmpty
                        ? NetworkImage(friend.profileImagePath!)
                    // : AssetImage('assets/img/test.jpg'),
                        : NetworkImage("https://nld.mediacdn.vn/2019/1/23/iron-man-15482507516511342859204.jpg"),
                    // : AssetImage("https://nld.mediacdn.vn/2019/1/23/iron-man-15482507516511342859204.jpg") as ImageProvider,
                  ),
                  title: Text(friend.fullName, //?? "Không rõ tên"
                    style: TextStyle(fontWeight: FontWeight.bold),),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: friend.isFollowing ? Colors.grey : Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size(50, 30),
                    ),
                    // onPressed: () => toggleFollow(friend),
                    onPressed: () => toggleFollow(friend),
                    // icon: Icon(Icons.person_add),
                    child: Text(friend.isFollowing ? 'Unfollow' : 'Follow'),
                  ),
                  // trailing: ElevatedButton(
                  //   onPressed: () {
                  //     // Logic follow/unfollow sẽ đặt tại đây
                  //   },
                  //   child: Text('Follow'),
                  // ),
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
    home: FollowPageList(currentUserId: '6769113169cc2f1876d7a93e'),
    //   home: FollowPageList(currentUserId: '6752fa3671214d6a44ed7c59'),

  ));
}


