import 'dart:convert';

import '../models/bday_record.dart';
import 'package:bday/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

enum ImportStrategy { overwrite, skip, clean }

class ImportExportModal extends StatelessWidget {
  const ImportExportModal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Import/Export'),
      ),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.upload_rounded),
            title: const Text('Import Overwrite'),
            subtitle:
                const Text('This will overwrite any existing duplicates.'),
            onTap: () async {
              await _importData(context, ImportStrategy.overwrite)
                  .catchError((e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message),
                    ),
                  );
                }
              });
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_rounded),
            title: const Text('Import Skip'),
            subtitle: const Text('This will skip any existing duplicates.'),
            onTap: () async {
              await _importData(context, ImportStrategy.skip).catchError((e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message),
                    ),
                  );
                }
              });
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.upload_rounded),
            title: const Text('Import Clean'),
            subtitle: const Text(
                'This remove all entries and perform a clean import.'),
            onTap: () async {
              await _importData(context, ImportStrategy.clean).catchError((e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message),
                    ),
                  );
                }
              });
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.download_rounded),
            title: const Text('Export'),
            onTap: () async {
              await _exportData(context).catchError((e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.message),
                    ),
                  );
                }
              });
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
          ),
        ],
      ),
    );
  }

  Future<void> _importData(
      BuildContext context, ImportStrategy strategy) async {
    try {
      const params = OpenFileDialogParams(
        dialogType: OpenFileDialogType.document,
      );
      final filePath = await FlutterFileDialog.pickFile(params: params);
      if (filePath != null) {
        final file = File(filePath);
        final content = await file.readAsString();
        final StorageService? db;
        if (context.mounted) {
          db = context.read<StorageService>();
        } else {
          throw Exception('Failed to import data: context is not mounted');
        }

        if (strategy == ImportStrategy.clean) {
          db.clear(notify: false);
        }

        final List<dynamic> jsonData = await jsonDecode(content);
        for (var data in jsonData) {
          final record = await BDayRecord.fromJson(data);
          switch (strategy) {
            case ImportStrategy.overwrite:
              await db.replace(record, notify: false);
              break;
            case ImportStrategy.skip:
              await db.addOrSkip(record, notify: false);
              break;
            case ImportStrategy.clean:
              await db.add(record, notify: false);
              break;
          }
        }
        db.notify();
      }
    } catch (e) {
      throw Exception('Failed to import data: ${e.toString()}');
    }
  }

  Future<void> _exportData(BuildContext context) async {
    try {
      var data = await context.read<StorageService>().list();
      final bytes = utf8.encode(jsonEncode(data));

      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/export.bday');
      await file.writeAsBytes(bytes);

      final params = SaveFileDialogParams(
        sourceFilePath: file.path,
      );
      await FlutterFileDialog.saveFile(params: params);
    } catch (e) {
      throw Exception('Failed to export data: ${e.toString()}');
    }
  }
}
