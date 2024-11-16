import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class ItemDetailPage extends StatefulWidget {
  final String itemId;

  const ItemDetailPage({super.key, required this.itemId});

  @override
  State<ItemDetailPage> createState() => _ItemDetailPageState();
}

class _ItemDetailPageState extends State<ItemDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? itemData;

  @override
  void initState() {
    super.initState();
    fetchItemDetails();
  }

  Future<void> fetchItemDetails() async {
    try {
      DocumentSnapshot docSnapshot =
          await _firestore.collection("items").doc(widget.itemId).get();
      setState(() {
        itemData = docSnapshot.data() as Map<String, dynamic>?;
      });
    } catch (e) {
      print("Error getting document: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          itemData?['name'] ?? 'Item Details',
          style: const TextStyle(color: Colors.black),
        ),
      ),
      body: itemData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  itemData?['imageUrl'] != null
                      ? (itemData?['imageUrl'] is List
                          ? Column(
                              children: (itemData?['imageUrl'] as List<dynamic>)
                                  .map((url) => Image.network(url))
                                  .toList(),
                            )
                          : Image.network(itemData?['imageUrl']))
                      : const Text('No Image Available'),
                  const SizedBox(height: 10),
                  Text('${itemData?['name'] ?? 'No Name'}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w600)),
                  const Text(
                    'Additional Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text('${itemData?['description'] ?? 'No Description'}'),
                  const SizedBox(height: 10),
                  Text('Category: ${itemData?['category'] ?? 'No Category'}'),
                  Text('Location: ${itemData?['location'] ?? 'No Location'}'),
                  Text(
                    'Time: ${itemData?['time'] != null ? DateFormat('MM/dd/yyyy').format((itemData?['time'] as Timestamp).toDate()) : 'No Date'}',
                  ),
                  Text(
                      'Is Claimed: ${itemData?['isClaimed'] == true ? 'Claimed' : 'Not Claimed'}'),
                  Text('Status: ${itemData?['status'] ?? 'No Status'}'),
                ],
              ),
            ),
    );
  }
}
