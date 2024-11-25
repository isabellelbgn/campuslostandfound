import 'package:cloud_firestore/cloud_firestore.dart';

class SearchService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addSearchQuery(String query, String userId) async {
    if (userId.isEmpty) return;

    try {
      final existingQuery = await _firestore
          .collection('searchHistory')
          .where('userId', isEqualTo: userId)
          .where('searchTerm', isEqualTo: query)
          .get();

      if (existingQuery.docs.isEmpty) {
        await _firestore.collection('searchHistory').add({
          'userId': userId,
          'searchTerm': query,
          'timestamp': FieldValue.serverTimestamp(),
        });
      } else {
        await existingQuery.docs.first.reference.update({
          'timestamp': FieldValue.serverTimestamp(),
        });
      }
    } catch (e) {
      print("Error saving search query: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> fetchSearchHistory(String userId) {
    if (userId.isEmpty) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('searchHistory')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> clearSearchHistory(String userId) async {
    if (userId.isEmpty) return;
    try {
      final batch = _firestore.batch();
      final querySnapshot = await _firestore
          .collection('searchHistory')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in querySnapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit();
    } catch (e) {
      print("Error clearing search history: $e");
    }
  }
}
