import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smart_school/features/auth/data/user_model.dart';
import 'package:smart_school/core/helpers/pref_helper.dart';

class FirebaseChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // =========================
  // CURRENT USER ID (FROM API)
  // =========================
  String? get currentUserId => PrefHelper.getUserId();

  // =========================
  // GET CURRENT USER
  // =========================
  Future<UserModel?> getCurrentUser() async {
    final myId = currentUserId;

    if (myId == null || myId.isEmpty) return null;

    final doc = await _firestore.collection('users').doc(myId).get();

    if (doc.exists) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }

    return null;
  }

  // =========================
  // GET USER BY ID
  // =========================
  Future<UserModel?> getUserById(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();

    if (doc.exists) {
      return UserModel.fromJson(doc.data() as Map<String, dynamic>);
    }

    return null;
  }

  // =========================
  // CREATE OR GET CHAT (STABLE ID)
  // =========================
  Future<String> createOrGetDirectChat(String otherUserId) async {
    final myId = currentUserId;

    if (myId == null || myId.isEmpty) {
      throw Exception("User not logged in");
    }

    final ids = [myId, otherUserId]..sort();
    final chatId = ids.join("_");

    final chatRef = _firestore.collection('chats').doc(chatId);
    final chatDoc = await chatRef.get();

    if (!chatDoc.exists) {
      await chatRef.set({
        'participants': [myId, otherUserId],
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'lastMessage': '',
        'unread_$myId': 0,
        'unread_$otherUserId': 0,
      }, SetOptions(merge: true));
    }

    return chatId;
  }

  // =========================
  // SEND MESSAGE
  // =========================
  Future<void> sendMessage({
    required String chatId,
    required String text,
    bool hasAttachment = false,
    String? attachmentUrl,
    String? attachmentName,
  }) async {
    final myId = currentUserId;

    if (myId == null || myId.isEmpty) {
      throw Exception("User not logged in");
    }

    final chatRef = FirebaseFirestore.instance.collection('chats').doc(chatId);

    final chatDoc = await chatRef.get();
    final participants = List<String>.from(chatDoc['participants']);

    final otherId = participants.firstWhere((id) => id != myId);

    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(myId)
        .get();

    final userName = userDoc.data()?['name'] ?? 'Unknown';

    /// =========================
    /// 1 - SEND MESSAGE
    /// =========================
    await chatRef.collection('messages').add({
      'text': text,
      'senderId': myId,
      'senderName': userName,
      'timestamp': FieldValue.serverTimestamp(),
      'isRead': false,
      'hasAttachment': hasAttachment,
      if (attachmentUrl != null) 'attachmentUrl': attachmentUrl,
      if (attachmentName != null) 'attachmentName': attachmentName,
    });

    /// =========================
    /// 2 - UPDATE CHAT INFO
    /// =========================
    await chatRef.set({
      'lastMessage': text,
      'updatedAt': FieldValue.serverTimestamp(),
      'unread_$otherId': FieldValue.increment(1),
    }, SetOptions(merge: true));

    /// =========================
    /// 3 - CREATE NOTIFICATION (IMPORTANT)
    /// =========================
    await FirebaseFirestore.instance.collection('notifications').add({
      'receiverId': otherId,
      'senderId': myId,
      'senderName': userName,
      'title': 'New message',
      'body': text,
      'type': 'chat',
      'relatedId': chatId,
      'isRead': false,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // =========================
  // STREAM MESSAGES (REALTIME)
  // =========================
  Stream<List<Map<String, dynamic>>> streamMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.data()).toList());
  }

  // =========================
  // STREAM ALL USERS (FOR CHAT LIST)
  // =========================
  Stream<List<Map<String, dynamic>>> streamAllUsers() {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  // =========================
  // STREAM USER CHATS (OPTIONAL FUTURE USE)
  // =========================
  Stream<Map<String, dynamic>?> streamUserChats() {
    final myId = currentUserId;

    if (myId == null || myId.isEmpty) {
      return const Stream.empty();
    }

    return _firestore
        .collection('userChats')
        .doc(myId)
        .snapshots()
        .map((doc) => doc.data());
  }

  Stream<List<Map<String, dynamic>>> streamUsersByRole(String myRole) {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).where((user) {
        final role = user['role'];

        if (myRole == 'teacher') {
          return role == 'parent';
        } else if (myRole == 'parent') {
          return role == 'teacher';
        }

        return false;
      }).toList();
    });
  }

  Future<String?> getMyRole() async {
    final myId = currentUserId;

    if (myId == null || myId.isEmpty) return null;

    final doc = await _firestore.collection('users').doc(myId).get();

    if (!doc.exists) return null;

    return doc.data()?['role'];
  }

  Stream<List<Map<String, dynamic>>> streamMyChats() {
    final myId = currentUserId;

    if (myId == null || myId.isEmpty) {
      return const Stream.empty();
    }

    return _firestore
        .collection('chats')
        .where('participants', arrayContains: myId)
        .snapshots()
        .asyncMap((snapshot) async {
          final chats = snapshot.docs.map((doc) {
            final data = doc.data();
            data['chatId'] = doc.id;
            return data;
          }).toList();

          for (var chat in chats) {
            final chatId = chat['chatId'];

            final msgSnap = await _firestore
                .collection('chats')
                .doc(chatId)
                .collection('messages')
                .orderBy('timestamp', descending: true)
                .limit(1)
                .get();

            if (msgSnap.docs.isNotEmpty) {
              chat['lastMessage'] = msgSnap.docs.first['text'];
              chat['lastTime'] = msgSnap.docs.first['timestamp'];
            } else {
              chat['lastMessage'] = '';
              chat['lastTime'] = null;
            }
          }

          return chats;
        });
  }

  Stream<List<Map<String, dynamic>>> searchUsers(String query, String myRole) {
    return _firestore.collection('users').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).where((user) {
        final role = user['role'];

        if (myRole == 'teacher') {
          if (role != 'parent') return false;
        } else if (myRole == 'parent') {
          if (role != 'teacher') return false;
        }

        final name = user['name'].toString().toLowerCase();
        final q = query.toLowerCase();

        return name.contains(q);
      }).toList();
    });
  }

  // =========================
  // CREATE INITIAL CHATS
  // =========================
  static Future<void> createInitialChats(String userId, String role) async {
    final firestore = FirebaseFirestore.instance;

    final oppositeRole = role == "teacher" ? "parent" : "teacher";

    final usersSnapshot = await firestore
        .collection("users")
        .where("role", isEqualTo: oppositeRole)
        .get();

    for (var doc in usersSnapshot.docs) {
      final otherId = doc['id'].toString();

      if (otherId == userId) continue;

      final ids = [userId, otherId]..sort();
      final chatId = ids.join("_");

      await firestore.collection("chats").doc(chatId).set({
        "participants": [userId, otherId],
        "lastMessage": "",
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
}
