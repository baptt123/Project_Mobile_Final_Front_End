import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MessageScreen extends StatefulWidget {
  final String groupId;

  MessageScreen({required this.groupId});

  @override
  _MessageScreenState createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  List<dynamic> messages = [];

  @override
  void initState() {
    super.initState();
    fetchMessages();
  }

  // Lấy danh sách tin nhắn từ API
  Future<void> fetchMessages() async {
    final response = await http.get(Uri.parse('http://your-api-url/api/messages/${widget.groupId}'));

    if (response.statusCode == 200) {
      setState(() {
        messages = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load messages');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Messages'),
      ),
      body: Column(
        children: [
          // Hiển thị danh sách tin nhắn
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message['senderId']),
                  subtitle: Text(message['content']),
                  trailing: Text(
                    formatTimestamp(message['timestamp']),
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                );
              },
            ),
          ),
          // Form gửi tin nhắn
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Handle text input
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Gửi tin nhắn (sẽ xử lý sau)
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Hàm định dạng thời gian
  String formatTimestamp(String timestamp) {
    final DateTime dateTime = DateTime.parse(timestamp);
    final String formatted = '${dateTime.hour}:${dateTime.minute}';
    return formatted;
  }
}
