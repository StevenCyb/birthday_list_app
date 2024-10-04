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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BDay List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.import_export),
            onPressed: () {
              _showImportExportDialog(context);
            },
          ),
        ],
      ),
      body: const BDayList(),
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
