import 'dart:convert';
import 'dart:math';

import 'package:app_chat/model/message.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();
    _channel = WebSocketChannel.connect(
      // Uri.parse('ws://your-server-address:port'), // Thay thế bằng địa chỉ WebSocket server của bạn
      Uri.parse('ws://192.168.67.104:8080/chat')
    );

    // Lắng nghe tin nhắn từ WebSocket server
    _channel.stream.listen((message) {
      setState(() {
        _messages.add("Other: $message");
      });
    });
  }

  @override
  void dispose() {
    _channel.sink.close(status.goingAway);
    super.dispose();
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      Random random=Random();
      Message message=Message(
        random.nextInt(1000),
        _controller.text,
        DateTime.now(),
        random.nextInt(500),
        random.nextInt(300)
      );
      String messageResult=jsonEncode(message);
      _channel.sink.add(messageResult);
      setState(() {
        _messages.add("You: ${_controller.text}");
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat App'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Enter your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
