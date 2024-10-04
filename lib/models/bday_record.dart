import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:bday/models/in_memory_file.dart';
import 'package:flutter/foundation.dart' show immutable;

@immutable
class BDayRecord {
  final File? image;
  final String name;
  final DateTime date;

  const BDayRecord({
    required this.image,
    required this.name,
    required this.date,
  });

  String bornString() {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }

  int daysTillBday() {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime nextBday = DateTime(today.year, date.month, date.day);

    if (nextBday.isBefore(today)) {
      nextBday = DateTime(today.year + 1, date.month, date.day);
    }

    Duration difference = nextBday.difference(today);
    return difference.inDays;
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "date": date.millisecondsSinceEpoch,
      "image": image?.readAsBytesSync(), // Store raw bytes of the image
    };
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "date": date.toIso8601String(),
      "image": image != null ? base64Encode(image!.readAsBytesSync()) : null,
    };
  }

  static Future<BDayRecord> fromMap(Map<String, dynamic> map) async {
    File? imageFile;

    if (map['image'] != null) {
      final imageData = Uint8List.fromList(List<int>.from(map['image']));
      final tempDir = Directory.systemTemp;
      imageFile = InMemoryFile(
          '${tempDir.path}/temp_image_${_generateRandomString(10)}.png',
          imageData);
    }

    return BDayRecord(
      name: map['name'],
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      image: imageFile,
    );
  }

  static Future<BDayRecord> fromJson(Map<String, dynamic> json) async {
    File? imageFile;

    if (json['image'] != null) {
      final imageData = base64Decode(json['image']);
      final tempDir = Directory.systemTemp;
      imageFile = InMemoryFile(
          '${tempDir.path}/temp_image_${_generateRandomString(10)}.png',
          imageData);
    }

    return BDayRecord(
      name: json['name'],
      date: DateTime.parse(json['date']),
      image: imageFile,
    );
  }

  static _generateRandomString(int i) {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random.secure();
    return List.generate(
      i,
      (index) => chars[random.nextInt(chars.length)]
    ).join();
  }
}
