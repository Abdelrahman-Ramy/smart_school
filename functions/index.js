const admin = require('firebase-admin');
const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const { logger } = require('firebase-functions');

admin.initializeApp();

const db = admin.firestore();

function normalizeRole(role) {
  return (role || '').toString().trim().toLowerCase();
}

function getMessageBody(data) {
  if (data?.hasAttachment || data?.attachmentUrl || data?.attachmentName) {
    return 'Sent an attachment';
  }

  return (data?.text || '').toString().trim() || 'New message';
}

function collectTokens(userData) {
  if (!userData) return [];

  const tokens = new Set();

  if (Array.isArray(userData.fcmTokens)) {
    userData.fcmTokens.forEach((token) => {
      if (token) tokens.add(token.toString());
    });
  }

  if (typeof userData.fcmToken === 'string' && userData.fcmToken) {
    tokens.add(userData.fcmToken);
  }

  if (typeof userData.fcm_token === 'string' && userData.fcm_token) {
    tokens.add(userData.fcm_token);
  }

  return Array.from(tokens);
}

async function createNotificationDoc({
  receiverId,
  senderId,
  senderName,
  title,
  body,
  type,
  relatedId,
}) {
  const notificationRef = db.collection('notifications').doc();

  const payload = {
    id: notificationRef.id,
    receiverId,
    senderId,
    senderName,
    title,
    body,
    type,
    relatedId,
    isRead: false,
    createdAt: admin.firestore.FieldValue.serverTimestamp(),
  };

  await notificationRef.set(payload);

  return payload;
}

async function sendPushNotification({
  receiverId,
  title,
  body,
  data,
}) {
  const userDoc = await db.collection('users').doc(receiverId).get();

  if (!userDoc.exists) {
    logger.warn('Receiver user document not found', { receiverId });
    return;
  }

  const userData = userDoc.data();
  const tokens = collectTokens(userData);

  if (tokens.length === 0) {
    logger.info('No FCM tokens available for receiver', { receiverId });
    return;
  }

  const response = await admin.messaging().sendEachForMulticast({
    tokens,
    notification: {
      title,
      body,
    },
    data: Object.fromEntries(
      Object.entries(data).map(([key, value]) => [key, String(value)]),
    ),
  });

  if (response.failureCount > 0) {
    logger.warn('Some FCM notifications failed to send', {
      receiverId,
      failureCount: response.failureCount,
    });
  }
}

exports.sendChatNotification = onDocumentCreated(
  'chats/{chatId}/messages/{messageId}',
  async (event) => {
    try {
      const snapshot = event.data;

      if (!snapshot) {
        logger.warn('Chat message snapshot missing');
        return;
      }

      const message = snapshot.data();
      const chatId = event.params.chatId;
      const senderId = (message?.senderId || '').toString();

      if (!senderId) {
        logger.warn('Chat message missing senderId', { chatId });
        return;
      }

      const chatDoc = await db.collection('chats').doc(chatId).get();

      if (!chatDoc.exists) {
        logger.warn('Chat document not found', { chatId });
        return;
      }

      const chatData = chatDoc.data() || {};
      const participants = Array.isArray(chatData.participants)
        ? chatData.participants.map((value) => value.toString())
        : [];

      if (participants.length < 2 || !participants.includes(senderId)) {
        logger.warn('Invalid chat participants', { chatId, senderId });
        return;
      }

      const receiverId = participants.find(
        (participantId) => participantId !== senderId,
      );

      if (!receiverId) {
        logger.warn('Receiver not found in chat participants', { chatId, senderId });
        return;
      }

      const senderDoc = await db.collection('users').doc(senderId).get();
      const receiverDoc = await db.collection('users').doc(receiverId).get();

      if (!senderDoc.exists || !receiverDoc.exists) {
        logger.warn('Sender or receiver user document missing', {
          chatId,
          senderId,
          receiverId,
        });
        return;
      }

      const senderData = senderDoc.data() || {};
      const receiverData = receiverDoc.data() || {};
      const senderRole = normalizeRole(senderData.role);
      const receiverRole = normalizeRole(receiverData.role);

      const validRoles =
        (senderRole === 'parent' && receiverRole === 'teacher') ||
        (senderRole === 'teacher' && receiverRole === 'parent');

      if (!validRoles) {
        logger.info('Skipping non parent-teacher chat notification', {
          chatId,
          senderId,
          receiverId,
          senderRole,
          receiverRole,
        });
        return;
      }

      const senderName =
        (senderData.name || message?.senderName || 'Unknown').toString();
      const body = getMessageBody(message);
      const title = senderName;

      const notification = await createNotificationDoc({
        receiverId,
        senderId,
        senderName,
        title,
        body,
        type: 'chat',
        relatedId: chatId,
      });

      await sendPushNotification({
        receiverId,
        title,
        body,
        data: {
          notificationId: notification.id,
          receiverId,
          senderId,
          senderName,
          title,
          body,
          type: 'chat',
          relatedId: chatId,
        },
      });
    } catch (error) {
      logger.error('sendChatNotification failed', error);
    }
  },
);
