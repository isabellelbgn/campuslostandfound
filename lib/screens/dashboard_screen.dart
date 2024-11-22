import 'package:blobs/blobs.dart' as blobs;
import 'package:campuslostandfound/main.dart';
import 'package:campuslostandfound/screens/items_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../components/search_bar.dart';
import '../components/category_filter.dart';
import '../components/item_container.dart';
import 'item_detail_screen.dart';

typedef FirestoreBlob = Blob;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedCategory = "All";

  Future<List<Map<String, dynamic>>> fetchItems(
      {bool showTodayOnly = true}) async {
    List<Map<String, dynamic>> itemsList = [];
    DateTime now = DateTime.now();
    DateTime startOfDay = DateTime(now.year, now.month, now.day);

    try {
      QuerySnapshot querySnapshot;
      if (showTodayOnly) {
        querySnapshot = await _firestore
            .collection("items")
            .where("time", isGreaterThanOrEqualTo: startOfDay)
            .where("time", isLessThan: startOfDay.add(const Duration(days: 1)))
            .get();
      } else {
        querySnapshot = await _firestore.collection("items").get();
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

  List<Map<String, dynamic>> _filterItems(List<Map<String, dynamic>> items) {
    List<Map<String, dynamic>> filteredItems = items;

    // Filter by category
    if (_selectedCategory != "All") {
      filteredItems = filteredItems
          .where((item) =>
              (item['category'] ?? '').toLowerCase() ==
              _selectedCategory.toLowerCase())
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filteredItems = filteredItems
          .where((item) =>
              (item['name'] ?? '')
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()) ||
              (item['description'] ?? '')
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase()))
          .toList();
    }

    return filteredItems;
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    double blobSize = screenHeight * 0.3;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: Stack(
          children: [
            Positioned(
              top: -140,
              left: -60,
              child: blobs.Blob.fromID(
                id: const ['18-6-103'],
                size: blobSize,
                styles: blobs.BlobStyles(
                  color: const Color(0xFFE0E6F6),
                ),
              ),
            ),
            Positioned(
              bottom: -160,
              left: screenWidth * 0.6,
              child: blobs.Blob.fromID(
                id: const ['18-6-103'],
                size: blobSize,
                styles: blobs.BlobStyles(
                  color: const Color(0xFF002EB0),
                ),
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'lib/assets/icons/logo.png',
                height: 100,
                width: 100,
                fit: BoxFit.contain,
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color(0xFF002EB0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Pending design for header
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About Us'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () async {
                Navigator.pop(context);
                bool? confirmSignOut = await showDialog<bool>(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Confirm Sign Out"),
                      content: const Text("Are you sure you want to sign out?"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, false);
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, true);
                          },
                          child: const Text("Sign Out"),
                        ),
                      ],
                    );
                  },
                );

                if (confirmSignOut == true) {
                  await _signOut();
                }
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            SearchItemBar(
              controller: _searchController,
              onSearch: () {
                setState(() {
                  _searchQuery = _searchController.text.trim();
                });
                // Perform the search logic here
              },
            ),
            const SizedBox(height: 10),
            CategoryFilter(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() {
                  _selectedCategory = category;
                });
              },
            ),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: fetchItems(showTodayOnly: true),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: SpinKitChasingDots(
                        color: Color(0xFF002EB0),
                        size: 50.0,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else {
                    List<Map<String, dynamic>> items = snapshot.data ?? [];
                    List<Map<String, dynamic>> filteredItems =
                        _filterItems(items);

                    return Column(
                      children: [
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Items Today",
                                style: TextStyle(
                                    color: Color(0xFF002EB0),
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const SeeAllItemsPage(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  foregroundColor: const Color(0xFF002EB0),
                                ),
                                child: const Text(
                                  "See All Items",
                                  style: TextStyle(color: Color(0xFF525660)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: filteredItems.isEmpty
                              ? const Center(
                                  child: Text(
                                  "No items found today.",
                                  style: TextStyle(color: Color(0xFFA8A8A8)),
                                ))
                              : ListView.builder(
                                  itemCount: filteredItems.length,
                                  itemBuilder: (context, index) {
                                    var item = filteredItems[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0), // Add spacing
                                      child: ItemContainer(
                                        item: item,
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ItemDetailPage(
                                                      itemId: item['id']),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
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
