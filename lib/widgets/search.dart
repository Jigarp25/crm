import 'package:flutter/material.dart';

typedef SearchResult = Map<String, String>;

class SharedSearch extends StatelessWidget {
  final List<SearchResult> data;
  final void Function(SearchResult) onSelect;

  const SharedSearch({super.key, required this.data, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return SearchAnchor(
      builder: (context, controller) {
        return IconButton(
          onPressed: () => controller.openView(),
          icon: const Icon(Icons.search),
        );
      },
      suggestionsBuilder: (context, controller) async {
        var query = controller.text.toLowerCase();
        await Future.delayed(const Duration(milliseconds: 300));

        if (query.isEmpty) return [];

        var resultList = data.where((item) {
          var title = item['title']?.toLowerCase() ?? '';
          var assignedTo = item['assignedTo']?.toLowerCase() ?? '';
          var customer = item['customer']?.toLowerCase() ?? '';
          return title.contains(query) ||
              assignedTo.contains(query) ||
              customer.contains(query);
        }).toList();

        return resultList.map((item) {
          final title = item['title'] ?? '';
          final assignedTo = item['assignedTo'] ?? '';
          final customer = item['customer'] ?? '';
          String subtitleText = '';

          if (customer.toLowerCase().contains(query)) {
            subtitleText = 'Customer: $customer';
          } else if (assignedTo.toLowerCase().contains(query)) {
            subtitleText = 'Assigned: $assignedTo';
          }

          return ListTile(
            title: Text(title),
            subtitle: Text(subtitleText),
            onTap: () {
              Navigator.pop(context);
              onSelect(item);
            },
          );
        }).toList();
      },
    );
  }
}
