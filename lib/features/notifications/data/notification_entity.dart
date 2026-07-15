import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String receiverId;
  final String senderId;
  final String senderName;
  final String title;
  final String body;
  final String type;
  final String relatedId;
  final bool isRead;
  final DateTime? createdAt;

  const NotificationEntity({
    required this.id,
    required this.receiverId,
    required this.senderId,
    required this.senderName,
    required this.title,
    required this.body,
    required this.type,
    required this.relatedId,
    required this.isRead,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id,
    receiverId,
    senderId,
    senderName,
    title,
    body,
    type,
    relatedId,
    isRead,
    createdAt,
  ];
}
