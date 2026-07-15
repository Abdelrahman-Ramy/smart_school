import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smart_school/core/helpers/pref_helper.dart';
import 'package:smart_school/features/notifications/data/notification_remote_data_source.dart';

class NotificationBadgeIcon extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  NotificationBadgeIcon({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final NotificationRemoteDataSource _remoteDataSource =
      NotificationRemoteDataSource(firestore: FirebaseFirestore.instance);

  @override
  Widget build(BuildContext context) {
    final userId = PrefHelper.getUserId();

    if (userId == null || userId.isEmpty) {
      return GestureDetector(
        onTap: onTap,
        child: Icon(icon, color: iconColor),
      );
    }

    return StreamBuilder<int>(
      stream: _remoteDataSource.watchUnreadCount(receiverId: userId),
      builder: (context, snapshot) {
        final unreadCount = snapshot.data ?? 0;

        return GestureDetector(
          onTap: onTap,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, color: iconColor),
              if (unreadCount > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
                      vertical: 2,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      unreadCount > 99 ? '99+' : unreadCount.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
