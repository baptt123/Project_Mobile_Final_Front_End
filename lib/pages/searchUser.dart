import 'package:flutter/material.dart';
import 'package:quick_social/models/searchModel.dart';
import 'package:quick_social/api/callingapi.dart';

// main.dart
void main() {
  runApp(UserSearchScreen());
}
class UserSearchScreen extends StatefulWidget {
  @override
  _UserSearchScreenState createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  List<User> users = [];
  String query = '';

  void searchUsers() async {
    if (query.isNotEmpty) {
      final results = await CallingAPI.fetchSearchUsers(query);
      setState(() {
        users = results.cast<User>();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search: ',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              onSubmitted: (value) => searchUsers(),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: user.profileImagePath.isNotEmpty
                      ? Image.network(user.profileImagePath)
                      : Icon(Icons.account_circle),
                  title: Text(user.fullName),
                  subtitle: Text('@${user.username}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
