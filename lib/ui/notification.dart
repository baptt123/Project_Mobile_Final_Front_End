import 'dart:convert';
import 'dart:math';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../model/notification.dart';
void main(){
  runApp(MaterialApp(
    home: NotificationScreen(),
  ));
}
class NotificationScreen extends StatefulWidget {
  @override
  _NotificationScreenState createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
   WebSocketChannel? _channel;
  final List<String> _notifications = [];

   void _sendNotification() {
     Random random=Random();
     Notifications notification = Notifications(
     random.nextInt(1000), // id
      random.nextInt(2000)   , // idUser
         'New notification at ${DateTime.now()}' // action
     );

     // Chuyển đối tượng Notification thành chuỗi JSON
     String notificationJson = jsonEncode(notification.toJSON());

     // Gửi chuỗi JSON qua WebSocket
     _channel?.sink.add(notificationJson);
   }


   @override
  void initState() {
    super.initState();
    _channel= WebSocketChannel.connect(Uri.parse('ws://192.168.67.103:8080/notifications'));
    _channel?.stream.listen((message) {
      setState(() {
        _notifications.add(message);
      });
    });
  }

  @override
  void dispose() {
    _channel?.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Notifications')),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _sendNotification,
            child: Text('Send Notification'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_notifications[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
