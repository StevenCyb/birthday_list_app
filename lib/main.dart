import 'package:bday/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'widgets/bday_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.initDB();

  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => StorageService(),
    child: const BDayApp(),
  ));
}
