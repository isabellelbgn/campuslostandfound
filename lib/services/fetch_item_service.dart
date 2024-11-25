import 'package:cloud_firestore/cloud_firestore.dart';

class ItemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> fetchItems({
    bool showTodayOnly = true,
  }) async {
    List<Map<String, dynamic>> itemsList = [];
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    try {
      QuerySnapshot querySnapshot;
      if (showTodayOnly) {
        querySnapshot = await _firestore
            .collection("items")
            .where("dateCreated", isGreaterThanOrEqualTo: startOfDay)
            .where("dateCreated",
                isLessThan: startOfDay.add(const Duration(days: 1)))
            .where("isHidden", isEqualTo: false)
            .get();
      } else {
        querySnapshot = await _firestore
            .collection("items")
            .where("isHidden", isEqualTo: false)
            .get();
      }

      for (var docSnapshot in querySnapshot.docs) {
        final itemData = docSnapshot.data() as Map<String, dynamic>;
        itemData['id'] = docSnapshot.id;
        itemsList.add(itemData);
      }
    } catch (e) {
      print("Error fetching items: $e");
    }
    return itemsList;
  }
}
