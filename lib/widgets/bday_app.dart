import 'package:bday/services/storage_service.dart';
import 'package:bday/theme/theme.dart';
import 'package:bday/widgets/import_export_modal.dart';
import 'package:flutter/material.dart';
import 'bday_list.dart';

void main() {
  runApp(const BDayApp());
}

class BDayApp extends StatelessWidget {
  const BDayApp({super.key});

  @override
  Widget build(BuildContext context) {
    final materialTheme = MaterialTheme(Theme.of(context).textTheme);

    return MaterialApp(
      title: "BDay List",
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: ThemeMode.system,
      home: const BDayHomePage(),
    );
  }
}

class BDayHomePage extends StatefulWidget {
  const BDayHomePage({super.key});

  @override
  BDayHomePageState createState() => BDayHomePageState();
}

class BDayHomePageState extends State<BDayHomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  SortOption _selectedSortOption = SortOption.byName;
  String filterQuery = '';
  bool _isSearchBarExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearchBarExpanded
            ? TextField(
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Search by name...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {
                    filterQuery = value;
                  });
                },
              )
            : const Text("BDay List"),
        actions: [
          IconButton(
            icon: Icon(_isSearchBarExpanded ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearchBarExpanded = !_isSearchBarExpanded;
                if (!_isSearchBarExpanded) {
                  filterQuery = '';
                  _searchController.clear();
                  _searchFocusNode.unfocus();
                } else {
                  _searchFocusNode.requestFocus();
                }
              });
            },
          ),
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            onSelected: (SortOption result) {
              setState(() {
                _selectedSortOption = result;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<SortOption>>[
              const PopupMenuItem<SortOption>(
                value: SortOption.byName,
                child: Text('By Name'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.byDate,
                child: Text('By Date'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.byAge,
                child: Text('By Age'),
              ),
              const PopupMenuItem<SortOption>(
                value: SortOption.byDaysLeft,
                child: Text('By Days Left'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.import_export),
            onPressed: () {
              _showImportExportDialog(context);
            },
          ),
        ],
      ),
      body: BDayList(
        sortOption: _selectedSortOption,
        filterQuery: filterQuery,
      ),
    );
  }

  void _showImportExportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ImportExportModal();
      },
    );
  }
}
