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

class SeeAllItemsPage extends StatefulWidget {
  const SeeAllItemsPage({super.key});

  @override
  State<SeeAllItemsPage> createState() => _SeeAllItemsPageState();
}

class _SeeAllItemsPageState extends State<SeeAllItemsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";
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
    if (query.isNotEmpty) {
      setState(() {
        _searchQuery = query;
      });
      final user = Provider.of<AuthState>(context, listen: false).user;
      _searchService.addSearchQuery(query, user?.uid ?? "");
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
        child: Column(
          children: [
            const SizedBox(height: 10),
            SearchInput(
              controller: _searchController,
              onSearch: _performSearch,
              focusNode: _searchFocusNode,
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
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
                      itemCount: filteredItems.length,
                      itemBuilder: (context, index) {
                        var item = filteredItems[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
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
