


import 'package:flutter/material.dart';
import 'package:quick_social/dto/notificationsdto.dart';
import 'package:quick_social/widgets/notification_tile.dart';

import '../api/callingapi.dart';
import '../widgets/layout/responsive_padding.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage>
    with AutomaticKeepAliveClientMixin {
  late Future<List<NotificationsDTO>> _notificationsFuture;

  @override
  void initState() {
    super.initState();
    _notificationsFuture = CallingAPI.fetchNotifications();
  }

  void markAllAsRead() {
    setState(() {
      _notificationsFuture = _notificationsFuture.then((notifications) {
        return notifications.map((e) {
          return NotificationsDTO(action: e.action + " (đã đọc)");
        }).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: ResponsivePadding(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Notifikasi', style: textTheme.headlineSmall),
                  TextButton.icon(
                    onPressed: markAllAsRead,
                    icon: const Icon(Icons.check),
                    label: const Text('Tandai telah dibaca'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ResponsivePadding(
        child: FutureBuilder<List<NotificationsDTO>>(
          future: _notificationsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Lỗi: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('Không có thông báo nào.'));
            } else {
              final notifications = snapshot.data!;
              return ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (_, index) {
                  return NotificationTile(
                    notification: notifications[index],
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
