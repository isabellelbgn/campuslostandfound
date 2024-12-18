import 'package:campuslostandfound/components/appbar/bottom_navbar.dart';
import 'package:campuslostandfound/components/appbar/items_app_bar.dart';
import 'package:campuslostandfound/components/search/search_history.dart';
import 'package:campuslostandfound/components/search/search_input.dart';
import 'package:campuslostandfound/screens/item_detail_screen.dart';
import 'package:campuslostandfound/services/auth_state.dart';
import 'package:campuslostandfound/services/item_service.dart';
import 'package:campuslostandfound/services/search_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import '../components/items/item_container.dart';
import '../components/category_filter.dart';

class SeeAllItemsPage extends StatefulWidget {
  const SeeAllItemsPage({super.key});

  @override
  State<SeeAllItemsPage> createState() => _SeeAllItemsPageState();
}

class _SeeAllItemsPageState extends State<SeeAllItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
  String _selectedCategory = "All";
  int _selectedIndex = 1;
  final ItemService _itemService = ItemService();
  final FocusNode _searchFocusNode = FocusNode();

  late final SearchService _searchService;

  @override
  void initState() {
    super.initState();
    _searchService = SearchService();
    _searchFocusNode.addListener(() {
      setState(() {});
    });
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

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _performSearch() {
    final query = _searchController.text.trim();
    final user = Provider.of<AuthState>(context, listen: false).user;

    if (user == null) return;

    setState(() {
      _searchQuery = query;
    });

    if (query.isNotEmpty) {
      _searchService.addSearchQuery(query, user.uid);
    }
  }

  void _clearSearchHistory() {
    final userId = Provider.of<AuthState>(context, listen: false).user?.uid;
    if (userId != null) {
      _searchService.clearSearchHistory(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = Provider.of<AuthState>(context);
    final currentUserId = authState.user?.uid;

    return Scaffold(
      appBar: ItemsAppBar(
        child: const Center(
          child: Text(
            'All Items',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF002EB0),
            ),
          ),
        ),
        onBackButtonPressed: () => Navigator.pushNamedAndRemoveUntil(
          context,
          '/home',
          (Route<dynamic> route) => false,
        ),
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                SearchInput(
                  controller: _searchController,
                  onSearch: _performSearch,
                  focusNode: _searchFocusNode,
                ),
                const SizedBox(height: 20),
                if (_searchFocusNode.hasFocus)
                  SearchHistory(
                    userId: currentUserId ?? "",
                    onSearchTermSelected: (term) {
                      setState(() {
                        _searchController.text = term;
                        _searchQuery = term;
                      });
                      _performSearch();
                    },
                    onClearHistory: _clearSearchHistory,
                  ),
                CategoryFilter(
                  selectedCategory: _selectedCategory,
                  onCategorySelected: (category) {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                ),
                const SizedBox(height: 10),
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _itemService.fetchItems(showTodayOnly: false),
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
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No items found."));
                    } else {
                      List<Map<String, dynamic>> items = snapshot.data!;
                      List<Map<String, dynamic>> filteredItems =
                          _filterItems(items);

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          var item = filteredItems[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                            child: ItemContainer(
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
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          )),
      bottomNavigationBar: BottomNavBarWidget(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
