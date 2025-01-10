import 'dart:convert';
import 'package:http/http.dart' as http;
// import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

import '../calling_api/callingapi.dart';
import '../model/friend.dart';

// // Hàm chạy ứng dụng
// void main() {
//   runApp(FriendListScreen());
// }
void main() {
  runApp(MaterialApp(
    home: FriendListScreen(),
  ));
}
class FriendListScreen extends StatefulWidget{
  @override
  _FriendListSceenState createState() => _FriendListSceenState();
}

class _FriendListSceenState extends State<FriendListScreen>{
  late Future<List<Friend>> _friendsFuture;
  List<Friend> _allFriends =[];
  List<Friend> _filteredFriends =[];
  final TextEditingController _searchController = TextEditingController();

void initState(){
  super.initState();
  _friendsFuture = CallingAPIFriends.fetchFriends() as Future<List<Friend>>;
  _searchController.addListener(_filterFriends);
  _loadFriends();
}
void _loadFriends() async{
  try{
    List<Friend> friends = (await CallingAPIFriends.fetchFriends()).cast<Friend>();
    setState(() {
      _allFriends = friends;
      _filteredFriends = friends;
    });
  } catch(error){
    print("Error loading friends: $error");
  }
}
void _filterFriends(){
  String query = _searchController.text.toLowerCase();
  setState(() {
    _filteredFriends = _allFriends.where((friend) => friend.fullName.toLowerCase().contains(query)).toList();
  });
}
  void _refreshFriends() {
    setState(() {
      _friendsFuture = CallingAPIFriends.fetchFriends() as Future<List<Friend>>;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Danh sách bạn bè'),
      bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search friends...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          ),
      ),
      ),
      body: FutureBuilder<List<Friend>>(
          future: _friendsFuture, 
          builder: (context, snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return Center(child: CircularProgressIndicator());
            } else if(snapshot.hasError){
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if(snapshot.hasData){
              final friends = snapshot.data!;
              return ListView.builder(
                  itemCount: friends.length,
                  itemBuilder: (context, index){
                    final friend = friends[index];
                    return ListTile(leading: CircleAvatar(backgroundImage: NetworkImage(friend.profileImagePath ??''),
                    ),
                    title: Text(friend.fullName),
                    trailing: IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () async{
                          await CallingAPIFriends.deleteFriend(friend.id as String);
                          _refreshFriends(); // cập nhật lại danh sách
                        },
                    ),
                    );
                  },
              );
            } else {
              return Center(child: Text('No friends found.'));
            }
          },
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
      onPressed:(){
        // ví dụ thêm bạn bè mới
        Friend newFriend = Friend(id: "123", fullName: "New Friend", profileImagePath: null, isFavorite: false);
        CallingAPIFriends.addFriend(newFriend as Map<String, dynamic>).then((_){
          _refreshFriends();
        });
      })
    );
    throw UnimplementedError();
  }


}