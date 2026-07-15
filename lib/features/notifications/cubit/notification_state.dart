import 'package:equatable/equatable.dart';
import 'package:smart_school/features/notifications/data/notification_model.dart';

enum NotificationStatus { initial, loading, success, failure }

class NotificationState extends Equatable {
  final NotificationStatus status;
  final List<NotificationModel> notifications;
  final int unreadCount;
  final bool showUnreadOnly;
  final String errorMessage;

  const NotificationState({
    this.status = NotificationStatus.initial,
    this.notifications = const [],
    this.unreadCount = 0,
    this.showUnreadOnly = false,
    this.errorMessage = '',
  });

  List<NotificationModel> get visibleNotifications {
    if (!showUnreadOnly) return notifications;
    return notifications.where((item) => !item.isRead).toList(growable: false);
  }

  NotificationState copyWith({
    NotificationStatus? status,
    List<NotificationModel>? notifications,
    int? unreadCount,
    bool? showUnreadOnly,
    String? errorMessage,
  }) {
    return NotificationState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
      showUnreadOnly: showUnreadOnly ?? this.showUnreadOnly,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    notifications,
    unreadCount,
    showUnreadOnly,
    errorMessage,
  ];
}
