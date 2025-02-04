import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GroupChatScreen extends StatefulWidget {
  @override
  _GroupChatScreenState createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  List<dynamic> friends = [];
  List<int> selectedFriends = [];
  String groupName = '';

  @override
  void initState() {
    super.initState();
    fetchFriends();
  }

  // Lấy danh sách bạn bè từ API
  Future<void> fetchFriends() async {
    final response = await http.get(Uri.parse('http://your-api-url/api/groups/friends/1')); // userId = 1
    if (response.statusCode == 200) {
      setState(() {
        friends = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load friends');
    }
  }

  // Tạo nhóm chat
  Future<void> createGroup() async {
    final response = await http.post(
      Uri.parse('http://your-api-url/api/groups/create'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'groupName': groupName,
        'members': selectedFriends,
      }),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Group created successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Group creation failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Group Chat')),
      body: Column(
        children: [
          TextField(
            onChanged: (value) {
              setState(() {
                groupName = value;
              });
            },
            decoration: InputDecoration(labelText: 'Group Name'),
          ),
          ElevatedButton(
            onPressed: createGroup,
            child: Text('Create Group'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return CheckboxListTile(
                  title: Text(friends[index]['name']),
                  value: selectedFriends.contains(friends[index]['id']),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selectedFriends.add(friends[index]['id']);
                      } else {
                        selectedFriends.remove(friends[index]['id']);
                      }
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
