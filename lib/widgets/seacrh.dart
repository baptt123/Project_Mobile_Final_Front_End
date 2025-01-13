import 'package:flutter/material.dart';
import 'package:quick_social/models/searchModel.dart';
import 'package:quick_social/api/callingapi.dart';


class SearchUserWidget extends StatefulWidget {
  const SearchUserWidget({Key? key}) : super(key: key);

  @override
  _SearchUserWidgetState createState() => _SearchUserWidgetState();
}

class _SearchUserWidgetState extends State<SearchUserWidget> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _users = [];
  bool _isLoading = false;

  void _searchUsers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final users = await CallingAPI.fetchSearchUsers(_searchController.text);
      setState(() {
        _users = users.cast<User>();
      });
    } catch (e) {
      print('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search for users',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.search),
                onPressed: _searchUsers,
              ),
            ),
          ),
        ),
        _isLoading
            ? const CircularProgressIndicator()
            : Expanded(
          child: ListView.builder(
            itemCount: _users.length,
            itemBuilder: (context, index) {
              final user = _users[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(user.profileImagePath),
                ),
                title: Text(user.fullName),
                subtitle: Text('@${user.username}'),
              );
            },
          ),
        ),
      ],
    );
  }
}
