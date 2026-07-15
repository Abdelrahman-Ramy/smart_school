import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_school/core/helpers/pref_helper.dart';
import 'package:smart_school/features/notifications/cubit/notification_state.dart';
import 'package:smart_school/features/notifications/data/notification_model.dart';
import 'package:smart_school/features/notifications/data/notification_repository.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;
  StreamSubscription<List<NotificationModel>>? _notificationsSubscription;
  StreamSubscription<int>? _unreadCountSubscription;
  String? _currentUserId;
  

  NotificationCubit({required this.repository})
    : super(const NotificationState());

  Future<void> loadCurrentUserNotifications() async {
    final userId = PrefHelper.getUserId();

    if (userId == null || userId.isEmpty) {
      emit(
        state.copyWith(
          status: NotificationStatus.failure,
          errorMessage: 'User not logged in',
        ),
      );
      return;
    }

    _currentUserId = userId;

    await _notificationsSubscription?.cancel();
    await _unreadCountSubscription?.cancel();

    emit(state.copyWith(status: NotificationStatus.loading, errorMessage: ''));

    _notificationsSubscription = repository
        .watchNotifications(receiverId: userId)
        .listen(
          (notifications) {
            emit(
              state.copyWith(
                status: NotificationStatus.success,
                notifications: notifications,
              ),
            );
          },
          onError: (Object error, StackTrace stackTrace) {
            emit(
              state.copyWith(
                status: NotificationStatus.failure,
                errorMessage: error.toString(),
              ),
            );
          },
        );

    _unreadCountSubscription = repository
        .watchUnreadCount(receiverId: userId)
        .listen(
          (count) {
            emit(state.copyWith(unreadCount: count));
          },
          onError: (Object error, StackTrace stackTrace) {
            emit(
              state.copyWith(
                status: NotificationStatus.failure,
                errorMessage: error.toString(),
              ),
            );
          },
        );
  }

  void setUnreadOnly(bool value) {
    emit(state.copyWith(showUnreadOnly: value));
  }

  Future<void> markAsRead(String notificationId) {
    return repository.markAsRead(notificationId);
  }

  Future<void> markAllAsRead() async {
    final userId = _currentUserId ?? PrefHelper.getUserId();
    if (userId == null || userId.isEmpty) return;
    await repository.markAllAsRead(userId);
  }

  @override
  Future<void> close() async {
    await _notificationsSubscription?.cancel();
    await _unreadCountSubscription?.cancel();
    return super.close();
  }
}
