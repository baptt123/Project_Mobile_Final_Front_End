import 'package:flutter/material.dart';
import 'package:quick_social/api/callingapi.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/message.dart';

class ChatApp extends StatelessWidget {
  final String username;
  ChatApp({required this.username});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: ChatScreen(username: username),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String username;
  ChatScreen({required this.username});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel _channel;

  final List<Map<String, dynamic>> messages = [];

  @override
  void initState() {
    super.initState();
    _fetchMessages(); // lay tin nhan tu API

    _channel = IOWebSocketChannel.connect('ws://192.168.100.143:8080/chat?username=${widget.username}');

    _channel.stream.listen((data) {
      final decodedMessage = json.decode(data);
      setState(() {
        messages.insert(0, {//them tin nhan moi o dau
          'id': decodedMessage['id'],
          'sender': decodedMessage['userNameSender'],
          'text': decodedMessage['message'],
          'sendingDate': DateTime.parse(decodedMessage['sendingDate']),
        });
      });
    });
  }

  Future<void> _fetchMessages() async {
    try {
      final fetchedMessages = await CallingAPI.fetchMessages(widget.username,'userNameReceiver');
      setState(() {
        messages.addAll(fetchedMessages);
      });
    } catch (error) {
      print('Error fetching messages: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('💬 chém-gió'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5.0,
                      horizontal: 10.0,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "User: ${message['sender']}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            message['text'],
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Text(
                            "${message['sendingDate']}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      final message = Messages(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        message: _controller.text,
                        sendingDate: DateTime.now(),
                       userNameSender: widget.username, // username nguoi gui
                        userNameReceiver: 'userNameReceiver', // username nguoi nhan
                      );

                      _channel.sink.add(json.encode(message.toJson()));
                      setState(() {
                        messages.insert(0, {
                          'id': message.id,
                          'userNameSender': message.userNameSender,
                          'text': message.message,
                          'sendingDate': message.sendingDate,
                        });
                      });
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _channel.sink.close();
    super.dispose();
  }
}

// services/message_service.dart
// class MessageService {
//   static Future<List<Map<String, dynamic>>> fetchMessages() async {
//     final response = await http.get(Uri.parse('http://192.168.67.107:8080/api/messages'));
//     if (response.statusCode == 200) {
//       final List<dynamic> fetchedMessages = json.decode(response.body);
//       return fetchedMessages.map((message) => {
//         'id': message['id'],
//         'sender': message['idSender'],
//         'text': message['message'],
//         'sendingDate': DateTime.parse(message['sendingDate']),
//       }).toList();
//     } else {
//       throw Exception('Failed to fetch messages: ${response.statusCode}');
//     }
//   }
// }
