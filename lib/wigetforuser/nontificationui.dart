import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../config/AppConfig.dart';
import '../model/notification.dart';
import '../models/notifications.dart';
import '../models/user.dart';

void main() async {
  await GetStorage.init(); // Khởi tạo GetStorage
  runApp(MaterialApp(
    home: NotificationScreenUI(),
  ));
}

class NotificationScreenUI extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreenUI> {
  WebSocketChannel? _channel;
  final List<Notifications> _notifications = [];
  User? currentUser;
  String? currentUserId;
  static const String wsUrl = "${AppConfig.wsUrl}/notifications";

  @override
  void initState() {
    super.initState();
    _connectServer();
    _loadUser();
    _loadNotifications(); // Tải thông báo từ GetStorage
  }

  Future<void> _loadUser() async {
    final box = GetStorage();
    String? userJsonString = box.read('user');
    if (userJsonString != null) {
      Map<String, dynamic> userJson = jsonDecode(userJsonString);
      setState(() {
        currentUser = User.fromJson(userJson);
        currentUserId = currentUser?.id;
      });
    }
  }

  /// Tải thông báo từ GetStorage
  Future<void> _loadNotifications() async {
    final box = GetStorage();
    String? notificationsJsonString = box.read('notifications');
    if (notificationsJsonString != null) {
      List<dynamic> notificationsJson = jsonDecode(notificationsJsonString);
      setState(() {
        _notifications.addAll(notificationsJson.map((e) => Notifications.fromJson(e)).toList());
      });
    }
  }

  /// Lưu thông báo vào GetStorage
  Future<void> _saveNotifications() async {
    final box = GetStorage();
    List<Map<String, dynamic>> notificationsJson = _notifications.map((e) => e.toJson()).toList();
    await box.write('notifications', jsonEncode(notificationsJson));
  }

  /// Kết nối tới server WebSocket
  Future<void> _connectServer() async {
    try {
      print('Kết nối tới WebSocket: $wsUrl');
      _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
      print('Kết nối thành công');
    } catch (e) {
      print('Không thể kết nối tới WebSocket: $e');
    }

    _channel?.stream.listen(
          (message) {
        print('Nhận được thông báo: $message');
        try {
          Map<String, dynamic> json = jsonDecode(message);
          Notifications notification = Notifications.fromJson(json);
          if (notification.idUser == currentUserId) {
            setState(() {
              _notifications.insert(
                  0, notification); // Thêm thông báo vào đầu danh sách
            });
            _saveNotifications(); // Lưu lại danh sách sau khi có thông báo mới
          } else {
            print('Thông báo không thuộc về người dùng này');
          }
        } catch (e) {
          print('Lỗi khi xử lý thông báo: $e');
        }
      },
      onDone: () {
        print('Kết nối đã đóng');
        _reconnect();
      },
      onError: (error) {
        print('Lỗi kết nối WebSocket: $error');
        _reconnect();
      },
    );
  }

  /// Thử kết nối lại nếu WebSocket bị ngắt
  Future<void> _reconnect() async {
    print('Thử kết nối lại sau 3 giây...');
    await Future.delayed(Duration(seconds: 3));
    _connectServer();
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Danh Sách Thông Báo"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: _notifications.length,
          itemBuilder: (context, index) {
            return Card(
              margin: EdgeInsets.symmetric(vertical: 8.0),
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: ListTile(
                contentPadding: EdgeInsets.all(12.0),
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(
                    Icons.notifications,
                    color: Colors.blue.shade800,
                  ),
                ),
                title: Text(
                  _notifications[index].action, // Hiển thị nội dung "action"
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  'Thông báo mới - ${DateTime.now().toLocal()}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
                trailing: Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade600,
                  size: 16,
                ),
                onTap: () {
                  // Hành động khi người dùng nhấn vào thông báo
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Bạn đã chọn thông báo: ${_notifications[index].action}"),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
