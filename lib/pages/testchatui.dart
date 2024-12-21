// import 'dart:convert';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_chat_ui/flutter_chat_ui.dart';
// import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
// import 'package:web_socket_channel/web_socket_channel.dart';
// import 'package:app_chat/model/message.dart'; // Import model Message
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Chat UI',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: ChatScreen(),
//     );
//   }
// }
//
// class ChatScreen extends StatefulWidget {
//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }
//
// class _ChatScreenState extends State<ChatScreen> {
//   final List<types.Message> _messages = [];
//   final types.User _currentUser = types.User(id: 'user1'); // Người dùng hiện tại
//   late WebSocketChannel _channel;
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Kết nối tới WebSocket server
//     _channel = WebSocketChannel.connect(
//       Uri.parse('ws://192.168.67.103:8080/chat'), // Đổi thành URL WebSocket server của bạn
//     );
//
//     // Lắng nghe tin nhắn từ server
//     _channel.stream.listen((data) {
//       final decoded = json.decode(data);
//
//       // Chuyển đổi JSON sang đối tượng Message
//       final newMessage = Messages.fromJson(decoded);
//
//       // Đổi thành types.Message để sử dụng với flutter_chat_types
//       final chatMessage = types.TextMessage(
//         author: types.User(id: newMessage.idSender.toString()), // Chuyển idSender thành String
//         createdAt: newMessage.sendingDate.millisecondsSinceEpoch,
//         id: newMessage.id.toString(),
//         text: newMessage.message,
//       );
//
//       setState(() {
//         _messages.insert(0, chatMessage);
//       });
//     });
//   }
//
//   @override
//   void dispose() {
//     // Đóng kết nối WebSocket khi không dùng nữa
//     _channel.sink.close();
//     super.dispose();
//   }
//
//   void _onSendPressed(types.PartialText message) {
//     final newMessage = Messages(
//       id: Random().nextInt(1000),
//       message: message.text,
//       sendingDate: DateTime.now(),
//       idSender: 1, // ID của người gửi (thay đổi theo người dùng thực tế)
//       idReceipt: 2, // ID của người nhận (thay đổi theo người nhận thực tế)
//     );
//
//     // Gửi tin nhắn qua WebSocket
//     _channel.sink.add(json.encode(newMessage.toJson()));
//
//     setState(() {
//       _messages.insert(0, types.TextMessage(
//         author: _currentUser,
//         createdAt: DateTime.now().millisecondsSinceEpoch,
//         id: newMessage.id.toString(),
//         text: message.text,
//       ));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Chat')),
//       body: Chat(
//         messages: _messages,
//         onSendPressed: _onSendPressed,
//         user: _currentUser, // Chỉ định người dùng hiện tại
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/message.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat UI',
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
  final List<types.Message> _messages = [];
  final types.User _currentUser = types.User(id: 'user1'); // Người dùng hiện tại
  late WebSocketChannel _channel;

  @override
  void initState() {
    super.initState();

    // Kết nối tới WebSocket server
    _channel = WebSocketChannel.connect(
      Uri.parse('ws://192.168.14.16:8080/chat'), // Đổi thành URL WebSocket server của bạn
    );

    // Lắng nghe tin nhắn từ server
    _channel.stream.listen((data) {
      final decoded = json.decode(data);

      // Chuyển đổi JSON sang đối tượng Message
      final newMessage = Messages.fromJson(decoded);

      // Đổi thành types.Message để sử dụng với flutter_chat_types
      final chatMessage = types.TextMessage(
        author: types.User(id: newMessage.idSender.toString()), // Chuyển idSender thành String
        createdAt: newMessage.sendingDate.millisecondsSinceEpoch,
        id: newMessage.id.toString(),
        text: newMessage.message,
      );

      setState(() {
        _messages.insert(0, chatMessage);
      });
    });
  }

  @override
  void dispose() {
    // Đóng kết nối WebSocket khi không dùng nữa
    _channel.sink.close();
    super.dispose();
  }

  void _onSendPressed(types.PartialText message) {
    final newMessage = Messages(
      id: Random().nextInt(1000),
      message: message.text,
      sendingDate: DateTime.now(),
      idSender: 1, // ID của người gửi (thay đổi theo người dùng thực tế)
      idReceipt: 2, // ID của người nhận (thay đổi theo người nhận thực tế)
    );

    // Gửi tin nhắn qua WebSocket
    _channel.sink.add(json.encode(newMessage.toJson()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat')),
      body: Chat(
        messages: _messages,
        onSendPressed: _onSendPressed,
        user: _currentUser, // Chỉ định người dùng hiện tại
        bubbleBuilder: _bubbleBuilder, // Tùy chỉnh hiển thị tin nhắn
      ),
    );
  }

  /// Tùy chỉnh hiển thị bong bóng tin nhắn (luôn ở bên trái)
  Widget _bubbleBuilder(
      Widget child, {
        required types.Message message,
        required bool nextMessageInGroup,
      }) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.grey[300], // Màu nền cho tin nhắn
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}


