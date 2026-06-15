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
      });
    }

    return chatId;
  }

  // =========================
  // SEND MESSAGE
  // =========================
  Future<void> sendMessage({
    required String chatId,
    required String text,
  }) async {
    final myId = currentUserId;

    if (myId == null || myId.isEmpty) {
      throw Exception("User not logged in");
    }

    final userDoc = await _firestore.collection('users').doc(myId).get();
    final userName = userDoc.data()?['name'] ?? 'Unknown';

    final chatRef = _firestore.collection('chats').doc(chatId);

    await chatRef.collection('messages').add({
      'text': text,
      'senderId': myId,
      'senderName': userName,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await chatRef.update({
      'lastMessage': text,
      'updatedAt': FieldValue.serverTimestamp(),
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
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            final data = doc.data();
            data['chatId'] = doc.id;
            return data;
          }).toList();
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
}
