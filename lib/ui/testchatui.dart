
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
  User? currentUser; // Thông tin người dùng hiện tại
  String? fullNameReceiver; // Tên đầy đủ của người nhận
  final TextEditingController _controller = TextEditingController();
  late WebSocketChannel _channel;
  final ScrollController _scrollController = ScrollController();
  List<Map<String, dynamic>> messages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();

    _initializeChat();
  }

  /// Lấy thông tin người dùng hiện tại và người nhận từ GetStorage
  Future<void> _loadUserData() async {
    final box = GetStorage();

    // Lấy thông tin người dùng hiện tại
    String? userJsonString = box.read('user');
    if (userJsonString != null) {
      Map<String, dynamic> userJson = jsonDecode(userJsonString);
      currentUser = User.fromJson(userJson);
    }

    // Lấy thông tin người nhận từ GetStorage
    String? selectedUser = box.read('selectedUser');
    print(selectedUser); // Kiểm tra dữ liệu được lưu
    if (selectedUser != null) {
      setState(() {
        fullNameReceiver =
            selectedUser; // Lưu tên đầy đủ của người nhận
      });
    }
  }

  /// Khởi tạo WebSocket và tải tin nhắn
  Future<void> _initializeChat() async {
    try {
       _fetchMessages(); // Lấy tin nhắn từ API
      _connectWebSocket(); // Kết nối WebSocket
    } catch (error) {
      print('Error initializing chat: $error');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Kết nối WebSocket
  void _connectWebSocket() {
    _channel = IOWebSocketChannel.connect(
        'ws://192.168.54.153:8080/chat?username=${currentUser!.fullName}');

    _channel.stream.listen(
      (data) {
        final decodedMessage = json.decode(data);
        setState(() {
          messages.add({
            'id': decodedMessage['id'],
            'fullNameSender': decodedMessage['fullNameSender'],
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
      },
    );
  }

  /// Lấy danh sách tin nhắn từ API
  Future<void> _fetchMessages() async {
    try {
      final fetchedMessages = await CallingAPI.fetchMessages(
          currentUser!.fullName ?? '', fullNameReceiver ?? '');

      setState(() {
        messages.clear(); // Làm mới danh sách tin nhắn
        if (fetchedMessages.isNotEmpty) {
          messages.addAll(fetchedMessages);
        }
      });
    } catch (error) {
      print('Error fetching messages: $error');
    }
  }

  /// Gửi tin nhắn qua WebSocket
  Future<void> _sendMessage() async {
    if (_controller.text.isNotEmpty) {
      try {
        final message = Messages(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          message: _controller.text,
          sendingDate: DateTime.now(),
          fullNameSender: currentUser?.fullName ?? '',
          fullNameReceiver: fullNameReceiver ?? '',
        );

        _channel.sink.add(json.encode(message.toJson()));
        setState(() {
          messages.add({
            'id': message.id,
            'fullNameSender': message.fullNameSender,
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
      }
    }
  }

  /// Cuộn xuống cuối danh sách tin nhắn
  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  /// Giao diện hiển thị tin nhắn
  Widget _buildMessageBubble(Map<String, dynamic> message) {
    return Align(
      alignment: message['fullNameSender'] == currentUser!.fullName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
        child: Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: message['fullNameSender'] == currentUser!.fullName
                ? Colors.blue[400]
                : Colors.grey[800],
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                message['fullNameSender'] ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 5.0),
              Text(
                message['text'] ?? '',
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

  /// Giao diện nhập tin nhắn
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
        title: Text('💬 Chat với $fullNameReceiver'),
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
                    ? Center(
                        child: Text('Chưa có tin nhắn nào'),
                      )
                    : ListView.builder(
                        controller: _scrollController,
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
