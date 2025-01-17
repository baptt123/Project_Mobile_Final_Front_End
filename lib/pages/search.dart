import 'package:flutter/material.dart';
import 'package:quick_social/models/user.dart';
import 'package:quick_social/api/callingapi.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({Key? key}) : super(key: key);

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen> {
  List<User> users = [];
  String query = '';
  bool isLoading = false;
  String? error;

  Future<void> searchUsers() async {
    if (query.isEmpty) {
      setState(() {
        users = [];
        error = null;
      });
      return;
    }

    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final results = await CallingAPI.fetchSearchUsers(query);
      setState(() {
        users = results;
      });
    } catch (e) {
      setState(() {
        error = 'Error fetching users: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Users'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Enter username or full name',
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
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : error != null
                ? Center(child: Text(error!, style: const TextStyle(color: Colors.red)))
                : users.isEmpty
                ? const Center(child: Text('No users found'))
                : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  leading: user.profileImagePath.isNotEmpty
                      ? CircleAvatar(
                    backgroundImage: NetworkImage(user.profileImagePath),
                  )
                      : const Icon(Icons.account_circle),
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
