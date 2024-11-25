import 'package:cloud_firestore/cloud_firestore.dart';

class Config {
  static const String _adminId = "qxekciTAKXMPzSi7Xy1A7CXvLXd2";
}

class MessageService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String message,
  }) async {
    try {
      await _firestore.collection('messages').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'message': message,
        'timestamp': FieldValue.serverTimestamp(),
        'isRead': false,
      });
    } catch (e) {
      print('Error sending message: $e');
    }
  }

  Stream<List<Map<String, dynamic>>> fetchMessages(String userId) {
    if (userId.isEmpty) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('messages')
        .where('receiverId', isEqualTo: Config._adminId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }
}
