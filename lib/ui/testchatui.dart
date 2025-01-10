import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../api/callingapi.dart';
import '../models/message.dart';
import '../models/user.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User? currentUser; // Biến để lưu thông tin người dùng
  String? userName;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _initializeChat();
  }

  // Hàm để lấy thông tin người dùng từ GetStorage
  Future<void> _loadUser() async {
    final box = GetStorage();
    String? userJsonString = box.read('user');
    if (userJsonString != null) {
      // Giải mã JSON thành đối tượng User
      Map<String, dynamic> userJson = jsonDecode(userJsonString);
      // setState(() {
      //   currentUser = User.fromJson(userJson);
      //   username = currentUser?.username;
      // });
      currentUser=User.fromJson(userJson);
      userName=currentUser?.username;
    }
  }

  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel _channel;
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  bool isLoading = true;

  Future<void> _initializeChat() async {
    try {
      await _fetchMessages();
      _connectWebSocket();
    } catch (error) {
      print('Error initializing chat: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _connectWebSocket() {
    _channel = IOWebSocketChannel.connect(
        'ws://192.168.15.62:8080/chat?username='+userName!);

    _channel.stream.listen(
      (data) {
        final decodedMessage = json.decode(data);
        setState(() {
          messages.add({
            'id': decodedMessage['id'],
            'userNameSender': decodedMessage['userNameSender'],
            'text': decodedMessage['message'],
            'sendingDate': DateTime.parse(decodedMessage['sendingDate']),
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        });
      },
      onError: (error) {
        print('WebSocket error: $error');
        // Có thể thêm xử lý hiển thị thông báo lỗi cho người dùng
      },
    );
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Future<void> _fetchMessages() async {
    try {
      final fetchedMessages =
          await CallingAPI.fetchMessages(userName!, 'userNameReceiver');

      setState(() {
        messages.clear(); // Làm mới lại danh sách tin nhắn
        if (fetchedMessages.isNotEmpty) {
          messages.addAll(
              fetchedMessages); // Nếu có tin nhắn thì thêm vào danh sách
        } else {
          // Trường hợp không có tin nhắn (mảng rỗng)
          print('Chưa có tin nhắn nào');
        }
      });
    } catch (error) {
      print('Error fetching messages: $error');
    }
  }

  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      try {
        final message = Messages(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: _controller.text,
          sendingDate: DateTime.now(),
          userNameSender: userName??'',
          userNameReceiver: 'userNameReceiver',
        );

        _channel.sink.add(json.encode(message.toJson()));
        setState(() {
          messages.add({
            'id': message.id,
            'userNameSender': message.userNameSender,
            'text': message.message,
            'sendingDate': message.sendingDate,
          });

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToBottom();
          });
        });
        _controller.clear();
      } catch (e) {
        print('Error sending message: $e');
        // Có thể thêm thông báo lỗi cho người dùng
      }
    }
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Chưa có tin nhắn nào',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Hãy bắt đầu cuộc trò chuyện!',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
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
                "User: ${message['userNameSender']}",
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
  }

  Widget _buildMessageInput() {
    return Padding(
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
              onSubmitted: (_) => _sendMessage(),
            ),
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.send),
            onPressed: _sendMessage,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('💬 chém-gió'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _fetchMessages,
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : messages.isEmpty
                    ? _buildEmptyState() // Hiển thị trạng thái rỗng nếu không có tin nhắn
                    : ListView.builder(
                        controller: _scrollController,
                        reverse: false,
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          return _buildMessageBubble(messages[index]);
                        },
                      ),
          ),
          Divider(height: 1),
          _buildMessageInput(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _channel.sink.close();
    super.dispose();
  }
}
