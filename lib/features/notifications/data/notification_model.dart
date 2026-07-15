import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_school/features/notifications/data/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.receiverId,
    required super.senderId,
    required super.senderName,
    required super.title,
    required super.body,
    required super.type,
    required super.relatedId,
    required super.isRead,
    required super.createdAt,
  });

  factory NotificationModel.fromMap(
    Map<String, dynamic> map, {
    String? documentId,
  }) {
    return NotificationModel(
      id: (map['id'] ?? documentId ?? '').toString(),
      receiverId: (map['receiverId'] ?? '').toString(),
      senderId: (map['senderId'] ?? '').toString(),
      senderName: (map['senderName'] ?? '').toString(),
      title: (map['title'] ?? '').toString(),
      body: (map['body'] ?? '').toString(),
      type: (map['type'] ?? '').toString(),
      relatedId: (map['relatedId'] ?? '').toString(),
      isRead: map['isRead'] == true,
      createdAt: _parseDateTime(map['createdAt']),
    );
  }

  factory NotificationModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    return NotificationModel.fromMap(doc.data() ?? {}, documentId: doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'receiverId': receiverId,
      'senderId': senderId,
      'senderName': senderName,
      'title': title,
      'body': body,
      'type': type,
      'relatedId': relatedId,
      'isRead': isRead,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  NotificationModel copyWith({
    String? id,
    String? receiverId,
    String? senderId,
    String? senderName,
    String? title,
    String? body,
    String? type,
    String? relatedId,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      receiverId: receiverId ?? this.receiverId,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      relatedId: relatedId ?? this.relatedId,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
