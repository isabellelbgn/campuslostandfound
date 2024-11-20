import 'package:campuslostandfound/screens/item_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../components/item_container.dart';
import '../components/search_bar.dart';

class SeeAllItemsPage extends StatefulWidget {
  const SeeAllItemsPage({super.key});

  @override
  State<SeeAllItemsPage> createState() => _SeeAllItemsPageState();
}

class _SeeAllItemsPageState extends State<SeeAllItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  Future<List<Map<String, dynamic>>> fetchAllItems() async {
    List<Map<String, dynamic>> itemsList = [];

    try {
      QuerySnapshot querySnapshot =
          await FirebaseFirestore.instance.collection("items").get();
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

  List<Map<String, dynamic>> _filterItems(List<Map<String, dynamic>> items) {
    if (_searchQuery.isEmpty) {
      return items;
    } else {
      return items
          .where((item) =>
              (item['name'] ?? '')
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              (item['description'] ?? '')
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          "All Items",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            SearchItemBar(
              controller: _searchController,
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchAllItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("No items found."));
                  } else {
                    List<Map<String, dynamic>> items = snapshot.data!;
                    List<Map<String, dynamic>> filteredItems =
                        _filterItems(items);

                    return ListView.builder(
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        var item = filteredItems[index];
                        return ItemContainer(
                          item: item,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ItemDetailPage(itemId: item['id']),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}