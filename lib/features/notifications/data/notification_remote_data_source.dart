import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:smart_school/features/notifications/data/notification_model.dart';

class NotificationRemoteDataSource {
  final FirebaseFirestore _firestore;

  NotificationRemoteDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('notifications');

  Future<void> createNotification(NotificationModel notification) async {
    final doc = notification.id.isNotEmpty
        ? _collection.doc(notification.id)
        : _collection.doc();

    await doc.set(notification.copyWith(id: doc.id).toMap());
  }

  Stream<List<NotificationModel>> watchNotifications({
    required String receiverId,
    bool unreadOnly = false,
  }) {
    Query<Map<String, dynamic>> query = _collection
        .where('receiverId', isEqualTo: receiverId)
        .orderBy('createdAt', descending: true);
        print("FIRESTORE QUERY receiverId: $receiverId");

    if (unreadOnly) {
      query = query.where('isRead', isEqualTo: false);
    }

    return query.snapshots().map(
      (snapshot) => snapshot.docs
          .map((doc) => NotificationModel.fromDocument(doc))
          .toList(),
    );
    
  }

  Stream<int> watchUnreadCount({required String receiverId}) {
    return _collection
        .where('receiverId', isEqualTo: receiverId)
        .where('isRead', isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.size);
  }

  Future<void> markAsRead(String notificationId) async {
    await _collection.doc(notificationId).update({'isRead': true});
  }

  Future<void> markAllAsRead(String receiverId) async {
    final unreadSnapshot = await _collection
        .where('receiverId', isEqualTo: receiverId)
        .where('isRead', isEqualTo: false)
        .get();

    if (unreadSnapshot.docs.isEmpty) return;

    final batch = _firestore.batch();
    for (final doc in unreadSnapshot.docs) {
      batch.update(doc.reference, {'isRead': true});
    }
    await batch.commit();
  }
}
