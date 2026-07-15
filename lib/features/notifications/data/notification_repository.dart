import 'package:smart_school/features/notifications/data/notification_model.dart';
import 'package:smart_school/features/notifications/data/notification_remote_data_source.dart';

class NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepository({required this.remoteDataSource});

  Future<void> createNotification(NotificationModel notification) {
    return remoteDataSource.createNotification(notification);
  }

  Stream<List<NotificationModel>> watchNotifications({
    required String receiverId,
    bool unreadOnly = false,
  }) {
    return remoteDataSource.watchNotifications(
      receiverId: receiverId,
      unreadOnly: unreadOnly,
    );
  }

  Stream<int> watchUnreadCount({required String receiverId}) {
    return remoteDataSource.watchUnreadCount(receiverId: receiverId);
  }

  Future<void> markAsRead(String notificationId) {
    return remoteDataSource.markAsRead(notificationId);
  }

  Future<void> markAllAsRead(String receiverId) {
    return remoteDataSource.markAllAsRead(receiverId);
  }
}
