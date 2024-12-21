// import 'package:flutter/material.dart';
// import 'package:quick_social/models/models.dart';
//
// class NotificationTile extends StatefulWidget {
//   const NotificationTile({
//     super.key,
//     required this.notification,
//   });
//
//   final UserNotification notification;
//
//   @override
//   State<NotificationTile> createState() => _NotificationTileState();
// }
//
// class _NotificationTileState extends State<NotificationTile> {
//   late UserNotification _notification;
//
//   @override
//   void initState() {
//     super.initState();
//     _notification = widget.notification;
//   }
//
//   @override
//   void didUpdateWidget(covariant NotificationTile oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     _notification = widget.notification;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//
//     final DateTime dateTime = widget.notification.dateTime;
//
//     return ListTile(
//       onTap: () {
//         setState(() {
//           _notification = _notification.copyWith(isRead: true);
//         });
//       },
//       leading: Icon(
//         switch (widget.notification.type) {
//           NotificationType.like => Icons.favorite,
//           NotificationType.comment => Icons.chat_bubble,
//           NotificationType.follow => Icons.person_add,
//         },
//         color: _notification.isRead
//             ? theme.disabledColor
//             : theme.colorScheme.primary,
//       ),
//       title: Text(
//         widget.notification.message,
//         style: TextStyle(
//           color: _notification.isRead
//               ? theme.colorScheme.onSurface.withAlpha(150)
//               : null,
//         ),
//       ),
//       subtitle: Text(
//         '${dateTime.day}/${dateTime.month}/${dateTime.year}',
//         style: TextStyle(color: theme.disabledColor),
//       ),
//       trailing: _notification.isRead
//           ? null
//           : Container(
//               width: 10,
//               height: 10,
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.primary,
//                 shape: BoxShape.circle,
//               ),
//             ),
//     );
//   }
// }

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
