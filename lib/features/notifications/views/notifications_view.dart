import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:smart_school/core/theming/app_colors.dart';
import 'package:smart_school/core/theming/app_style.dart';
import 'package:smart_school/features/notifications/cubit/notification_cubit.dart';
import 'package:smart_school/features/notifications/cubit/notification_state.dart';
import 'package:smart_school/features/notifications/data/notification_model.dart';
import 'package:smart_school/features/notifications/data/notification_navigation.dart';
import 'package:smart_school/features/notifications/data/notification_remote_data_source.dart';
import 'package:smart_school/features/notifications/data/notification_repository.dart';
import 'package:smart_school/features/student/widgets/notification_tile.dart';

class NotificationsView extends StatelessWidget {
  
  const NotificationsView({super.key});

  IconData _iconForType(String type) {
    switch (type) {
      case 'chat':
        return Icons.chat_bubble_outline;
      case 'task':
        return Icons.task_alt;
      case 'material':
        return Icons.folder_open;
      case 'attendance':
        return Icons.how_to_reg;
      default:
        return Icons.notifications_none;
    }
  }

  Color _colorForType(String type) {
    switch (type) {
      case 'chat':
        return AppColors.primaryColor;
      case 'task':
        return AppColors.orangeColor;
      case 'material':
        return AppColors.greenColor;
      case 'attendance':
        return AppColors.redColor;
      default:
        return Colors.grey.shade700;
    }
  }

  String _formatDate(NotificationModel notification) {
    final createdAt = notification.createdAt;
    if (createdAt == null) return 'Just now';
    return DateFormat('MMM d, h:mm a').format(createdAt);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationCubit(
        repository: NotificationRepository(
          remoteDataSource: NotificationRemoteDataSource(),
        ),
      )..loadCurrentUserNotifications(),
      child: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          final cubit = context.read<NotificationCubit>();
          final notifications = state.visibleNotifications;

          return Scaffold(
            appBar: AppBar(
              backgroundColor: AppColors.whiteColor,
              scrolledUnderElevation: 0,
              elevation: 0,
              centerTitle: true,
              leading: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              title: Text(
                'Notifications (${state.unreadCount})',
                style: AppStyle.font22BlackW500,
              ),
              actions: [
                TextButton(
                  onPressed: state.notifications.isEmpty
                      ? null
                      : () => cubit.markAllAsRead(),
                  child: Text(
                    'Mark all read',
                    style: AppStyle.font14GreyW400.copyWith(
                      color: AppColors.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Gap(10.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 40.w),
                  child: Container(
                    height: 48.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.r),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => cubit.setUnreadOnly(false),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: !state.showUnreadOnly
                                    ? AppColors.primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'All',
                                style: !state.showUnreadOnly
                                    ? AppStyle.font14WhiteBold.copyWith(
                                        fontSize: 16.sp,
                                      )
                                    : AppStyle.font16BlackBold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => cubit.setUnreadOnly(true),
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: state.showUnreadOnly
                                    ? AppColors.primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Text(
                                'Unread',
                                style: state.showUnreadOnly
                                    ? AppStyle.font14WhiteBold.copyWith(
                                        fontSize: 16.sp,
                                      )
                                    : AppStyle.font16BlackBold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(16.h),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (state.status == NotificationStatus.loading &&
                          notifications.isEmpty) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primaryColor,
                          ),
                        );
                      }

                      if (state.status == NotificationStatus.failure &&
                          notifications.isEmpty) {
                        return Center(
                          child: Text(
                            state.errorMessage.isEmpty
                                ? 'Unable to load notifications'
                                : state.errorMessage,
                            textAlign: TextAlign.center,
                            style: AppStyle.font16BlackBold,
                          ),
                        );
                      }

                      if (notifications.isEmpty) {
                        return Center(
                          child: Text(
                            state.showUnreadOnly
                                ? 'No unread notifications'
                                : 'No notifications yet',
                            style: AppStyle.font16BlackBold.copyWith(
                              color: Colors.grey,
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: notifications.length,
                        itemBuilder: (context, index) {
                          final notification = notifications[index];

                          return NotificationTile(
                            title: notification.senderName,
                            subtitle: notification.body,
                            time: _formatDate(notification),
                            icon: _iconForType(notification.type),
                            iconColor: _colorForType(notification.type),
                            isRead: notification.isRead,
                            onTap: () async {
                              await cubit.markAsRead(notification.id);
                              if (!context.mounted) return;

                              await NotificationNavigation.openFromNotification(
                                context,
                                notification,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
