import 'package:flutter/material.dart';
import 'package:smart_school/features/chats/views/chat_view.dart';
import 'package:smart_school/features/notifications/data/notification_entity.dart';

class NotificationNavigation {
  static Future<void> openFromNotification(
    BuildContext context,
    NotificationEntity notification,
  ) async {
    switch (notification.type) {
      case 'chat':
        await Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChatView(
              chatId: notification.relatedId,
              otherUserName: notification.senderName,
            ),
          ),
        );
        return;

      case 'task':
        return;

      case 'material':
        return;

      case 'attendance':
        return;

      
      case 'grade':
        return;

      default:
        return;
    }
  }

  static Future<void> openFromNotificationPayload(
    GlobalKey<NavigatorState> navigatorKey,
    Map<String, dynamic> data,
  ) async {
    final context = navigatorKey.currentContext;
    if (context == null) return;

    final notification = NotificationEntity(
      id: (data['notificationId'] ?? '').toString(),
      receiverId: (data['receiverId'] ?? '').toString(),
      senderId: (data['senderId'] ?? '').toString(),
      senderName: (data['senderName'] ?? '').toString(),
      title: (data['title'] ?? '').toString(),
      body: (data['body'] ?? '').toString(),
      type: (data['type'] ?? '').toString(),
      relatedId: (data['relatedId'] ?? '').toString(),
      isRead: false,
      createdAt: null,
    );

    await openFromNotification(context, notification);
  }
}