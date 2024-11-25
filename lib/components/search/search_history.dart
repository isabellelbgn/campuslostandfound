import 'package:flutter/material.dart';
import 'package:campuslostandfound/services/search_service.dart';

class SearchHistory extends StatelessWidget {
  final String userId;
  final Function(String) onSearchTermSelected;
  final Function onClearHistory;

  const SearchHistory({
    super.key,
    required this.userId,
    required this.onSearchTermSelected,
    required this.onClearHistory,
  });

  @override
  Widget build(BuildContext context) {
    final searchQueryService = SearchService();

    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: searchQueryService.fetchSearchHistory(userId),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          children: [
            Wrap(
              spacing: 8.0,
              children: snapshot.data!.map((doc) {
                String term = doc['searchTerm'] ?? '';
                return ActionChip(
                  label: Text(term),
                  onPressed: () {
                    onSearchTermSelected(term);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => onClearHistory(),
              child: const Text("Clear History"),
            ),
          ],
        );
      },
    );
  }
}
