import 'package:flutter/material.dart';
import 'package:campuslostandfound/services/search_service.dart';

class SearchHistory extends StatelessWidget {
  final String userId;
  final Function(String) onSearchTermSelected;
  final VoidCallback onClearHistory;

  const SearchHistory({
    Key? key,
    required this.userId,
    required this.onSearchTermSelected,
    required this.onClearHistory,
  }) : super(key: key);

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                String term = snapshot.data![index]['searchTerm'] ?? '';
                return ListTile(
                  leading: const Icon(Icons.history, color: Colors.grey),
                  title: Text(term),
                  trailing: IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () async {
                      await searchQueryService.deleteSearchTerm(userId, term);
                    },
                  ),
                  onTap: () {
                    onSearchTermSelected(term);
                  },
                );
              },
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onClearHistory,
                  child: const Text(
                    "Clear all",
                    style: TextStyle(color: Color(0xFF002EB0)),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
