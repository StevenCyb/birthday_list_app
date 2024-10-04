import 'dart:typed_data';
import 'dart:convert';
import 'dart:io';

class InMemoryFile implements File {
  @override
  final String path;
  final Uint8List _data;
  final DateTime _date = DateTime.now();

  InMemoryFile(this.path, this._data);

  @override
  File get absolute => this;

  @override
  bool get isAbsolute => true;

  @override
  Directory get parent => Directory(path).parent;

  @override
  Uri get uri => Uri.file(path);

  @override
  Future<File> copy(String newPath) async {
    return InMemoryFile(newPath, Uint8List.fromList(_data));
  }

  @override
  File copySync(String newPath) {
    return InMemoryFile(newPath, Uint8List.fromList(_data));
  }

  @override
  Future<File> create({bool recursive = false, bool exclusive = false}) async {
    return this;
  }

  @override
  void createSync({bool recursive = false, bool exclusive = false}) {}

  @override
  Future<FileSystemEntity> delete({bool recursive = false}) async {
    return this;
  }

  @override
  void deleteSync({bool recursive = false}) {}

  @override
  Future<bool> exists() async {
    return true;
  }

  @override
  bool existsSync() {
    return true;
  }

  @override
  Future<DateTime> lastAccessed() {
    return Future.value(_date);
  }

  @override
  DateTime lastAccessedSync() {
    return _date;
  }

  @override
  Future<DateTime> lastModified() async {
    return _date;
  }

  @override
  DateTime lastModifiedSync() {
    return _date;
  }

  @override
  Future<int> length() async {
    return _data.length;
  }

  @override
  int lengthSync() {
    return _data.length;
  }

  @override
  Future<RandomAccessFile> open({FileMode mode = FileMode.read}) {
    throw UnimplementedError();
  }

  @override
  RandomAccessFile openSync({FileMode mode = FileMode.read}) {
    throw UnimplementedError();
  }

  @override
  Stream<List<int>> openRead([int? start, int? end]) {
    return Stream.fromIterable(
        [_data.sublist(start ?? 0, end ?? _data.length)]);
  }

  @override
  IOSink openWrite({FileMode mode = FileMode.write, Encoding encoding = utf8}) {
    throw UnimplementedError();
  }

  @override
  Future<Uint8List> readAsBytes() {
    return Future.value(_data);
  }

  @override
  Uint8List readAsBytesSync() {
    return _data;
  }

  @override
  Future<List<String>> readAsLines({Encoding encoding = utf8}) {
    return Future.value(encoding.decode(_data).split('\n'));
  }

  @override
  List<String> readAsLinesSync({Encoding encoding = utf8}) {
    return encoding.decode(_data).split('\n');
  }

  @override
  Future<String> readAsString({Encoding encoding = utf8}) {
    return Future.value(encoding.decode(_data));
  }

  @override
  String readAsStringSync({Encoding encoding = utf8}) {
    return encoding.decode(_data);
  }

  @override
  Future<File> rename(String newPath) {
    throw UnimplementedError();
  }

  @override
  File renameSync(String newPath) {
    throw UnimplementedError();
  }

  @override
  Future<String> resolveSymbolicLinks() {
    throw UnimplementedError();
  }

  @override
  String resolveSymbolicLinksSync() {
    throw UnimplementedError();
  }

  @override
  Future setLastAccessed(DateTime time) {
    return Future.value();
  }

  @override
  void setLastAccessedSync(DateTime time) {}

  @override
  Future setLastModified(DateTime time) {
    return Future.value();
  }

  @override
  void setLastModifiedSync(DateTime time) {}

  @override
  Future<FileStat> stat() {
    return Future.value(FileStat.stat(
      path,
    ));
  }

  @override
  FileStat statSync() {
    return FileStat.statSync(
      path,
    );
  }

  @override
  Stream<FileSystemEvent> watch(
      {int events = FileSystemEvent.all, bool recursive = false}) {
    throw UnimplementedError();
  }

  @override
  Future<File> writeAsBytes(List<int> bytes,
      {FileMode mode = FileMode.write, bool flush = false}) {
    throw UnimplementedError();
  }

  @override
  void writeAsBytesSync(List<int> bytes,
      {FileMode mode = FileMode.write, bool flush = false}) {}

  @override
  Future<File> writeAsString(String contents,
      {FileMode mode = FileMode.write,
      Encoding encoding = utf8,
      bool flush = false}) {
    throw UnimplementedError();
  }

  @override
  void writeAsStringSync(String contents,
      {FileMode mode = FileMode.write,
      Encoding encoding = utf8,
      bool flush = false}) {}
}
