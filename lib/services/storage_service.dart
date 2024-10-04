import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/bday_record.dart';

enum SortOption { byName, byDate, byAge, byDaysLeft }

Future<Database> _initDB() async {
  if (Platform.isAndroid || Platform.isIOS) {
    return openDatabase(
      join(await getDatabasesPath(), 'bday.db'),
      onCreate: (db, version) {
        return _onCreate(db, version);
      },
      version: 1,
    );
  }

  throw Exception("Unsupported platform ${Platform.operatingSystem}");
}

Future<void> _onCreate(Database db, int version) async {
  await db.execute(""" CREATE TABLE IF NOT EXISTS bday(
            name TEXT PRIMARY KEY NOT NULL,
            date INTEGER NOT NULL,
            image BLOB
          )
 """);
}

class StorageService extends ChangeNotifier {
  static late final Database db;

  static initDB() async {
    db = await _initDB();
  }

  Future<List<BDayRecord>> list({SortOption sortBy = SortOption.byName}) async {
    final List<Map<String, dynamic>> records = await db.query("bday");
    List<BDayRecord> bdayRecords =
        await Future.wait(records.map((record) async {
      return BDayRecord.fromMap(record);
    }).toList());

    switch (sortBy) {
      case SortOption.byName:
        bdayRecords.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOption.byDate:
        bdayRecords.sort((a, b) => a.date.compareTo(b.date));
        break;
      case SortOption.byAge:
        bdayRecords.sort((a, b) => a.age().compareTo(b.age()));
        break;
      case SortOption.byDaysLeft:
        bdayRecords
            .sort((a, b) => a.daysTillBday().compareTo(b.daysTillBday()));
        break;
    }

    return bdayRecords;
  }

  Future<void> add(BDayRecord record, {notify = true}) async {
    final existingRecord = await db.query(
      "bday",
      where: "name = ?",
      whereArgs: [record.name],
    );
    if (existingRecord.isNotEmpty) {
      throw Exception('Name already exists');
    }

    await db.insert(
      "bday",
      record.toMap(),
    );
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> addOrSkip(BDayRecord record, {notify = true}) async {
    await db.insert("bday", record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> replace(BDayRecord record, {notify = true}) async {
    await db.insert(
      "bday",
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> clear({notify = true}) async {
    await db.delete("bday");
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> remove(String name, {notify = true}) async {
    db.delete(
      "bday",
      where: "name = ?",
      whereArgs: [name],
    );
    if (notify) {
      notifyListeners();
    }
  }

  void notify() {
    notifyListeners();
  }
}
