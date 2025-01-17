

import 'package:flutter/material.dart';
import 'package:quick_social/dto/notificationsdto.dart';

class NotificationTile extends StatelessWidget {
  final NotificationsDTO notification;

  const NotificationTile({Key? key, required this.notification})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.notifications),
      title: Text(notification.action),
    );
  }
}
