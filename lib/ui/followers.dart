import 'package:flutter/material.dart';
import '../api/callingapi.dart';
import '../model/friend.dart';
import '../wigetforuser/profile.dart';

class FollowersPageList extends StatefulWidget {
  final String currentUserId;

  FollowersPageList({required this.currentUserId});

  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPageList> {
  late Future<List<Friend>> followersList;

  @override
  void initState() {
    super.initState();
    followersList = CallingAPI().fetchFollowers(widget.currentUserId);
  }

  Future<void> toggleFollowStatus(Friend friend) async {
    try {
      if (friend.isFollowers) {
        // Unfollow logic
        await CallingAPI().unfollowUser(widget.currentUserId, friend.id);
        setState(() {
          friend.isFollowers = false;
        });
      } else {
        // Follow logic
        await CallingAPI().followUser(widget.currentUserId, friend.id);
        setState(() {
          friend.isFollowers = true;
        });
      }
    } catch (e) {
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
        title: Text("Danh sách Followers"),
      ),
      body: FutureBuilder<List<Friend>>(
        future: followersList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Lỗi: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final followers = snapshot.data!;
            return ListView.builder(
              itemCount: followers.length,
              itemBuilder: (context, index) {
                final friend = followers[index];
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
                  leading: CircleAvatar(
                    backgroundImage: friend.profileImagePath != null &&
                        friend.profileImagePath!.isNotEmpty
                        ? NetworkImage(friend.profileImagePath!)
                        : NetworkImage(
                        "https://nld.mediacdn.vn/2019/1/23/iron-man-15482507516511342859204.jpg"),
                  ),
                  title: Text(
                    friend.fullName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  trailing: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                      friend.isFollowers ? Colors.grey : Colors.blue,
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size(50, 30),
                    ),
                    onPressed: () => toggleFollowStatus(friend),
                    child: Text(friend.isFollowers ? 'Bạn bè' : 'Follow lại'),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("Không có ai đang theo dõi bạn"));
          }
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FollowersPageList(currentUserId: '6766dc9428b9352cd4eed32c'),
  ));
}
