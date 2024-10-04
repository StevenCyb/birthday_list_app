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
  SortOption _selectedSortOption = SortOption.byDaysLeft;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BDay List"),
        actions: [
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
      body: BDayList(sortBy: _selectedSortOption),
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
