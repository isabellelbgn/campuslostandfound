import 'package:campuslostandfound/components/bottom_navbar.dart';
import 'package:campuslostandfound/components/dashboard_app_bar.dart';
import 'package:campuslostandfound/components/dashboard_drawer.dart';
import 'package:campuslostandfound/main.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    User? user = FirebaseAuth.instance.currentUser;
    String userEmail = user?.email ?? "No Email";
    String userName = user?.displayName ?? "Guest";

    return Scaffold(
      key: _scaffoldKey,
      appBar: DashboardAppBar(
        blobSize: screenHeight * 0.3,
        onMenuPressed: () {
          _scaffoldKey.currentState?.openEndDrawer();
        },
      ),
      endDrawer: DashboardDrawer(
        onSignOut: _signOut,
        userEmail: userEmail,
        userName: userName,
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
                                  Navigator.pushReplacementNamed(
                                      context, '/items');
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
                                          vertical: 8.0),
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
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
