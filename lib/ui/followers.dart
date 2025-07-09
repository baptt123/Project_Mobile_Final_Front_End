import 'package:flutter/material.dart';
import '../api/callingapi.dart';
import '../models/friend.dart';
import '../wigetforuser/profile.dart';

class FollowersPageList extends StatefulWidget {
  final String currentUserId;

  const FollowersPageList({Key? key, required this.currentUserId}) : super(key: key);

  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPageList> {
  late Future<List<Friend>> followersList;
  final apiService = CallingAPIService(); // Instance để gọi method không static

  @override
  void initState() {
    super.initState();
    _loadFollowers();
  }

  void _loadFollowers() {
    followersList = apiService.fetchFollowers(widget.currentUserId);
  }

  Future<void> toggleFollowStatus(Friend friend) async {
    try {
      if (friend.isFollowers) {
        await apiService.unfollowUser(widget.currentUserId, friend.id);
        setState(() {
          friend.isFollowers = false;
        });
      } else {
        await apiService.followUser(widget.currentUserId, friend.id);
        setState(() {
          friend.isFollowers = true;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Lỗi: $e"),
          backgroundColor: Colors.red,
        ),
      );
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
                        : const NetworkImage(
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
                      padding:
                      EdgeInsets.symmetric(horizontal: 8, vertical: 4),
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
