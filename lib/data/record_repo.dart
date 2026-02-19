import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:records_app/data/record_test_data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/record.dart';

class RecordRepository extends ChangeNotifier {
  RecordRepository([List<Record>? records])
    : _records = records?.toList() ?? [];

  final List<Record> _records;
  int get _nextId =>
      _records.isEmpty ? 1 : _records.map((e) => e.id ??  0).reduce(max) + 1;

  /// Returns a flat copy of all records.
  ///
  List<Record> get records => _records.toList();

  /// Deletes the record object with the given record id.
  /// Return true = delete ok, false = no record object with the given id found!
  ///
  bool delete(int id) {
    // Todo
    final recordindex = _records.indexWhere((record) => record.id == id);
    if (recordindex != -1) {
      _records.removeAt(recordindex);
      notifyListeners();
      return true;
    }
 
    return false;
  }

  bool deleteList(List<Record> recordsToDelete) {
    bool allDeleted = true;
    for (var record in recordsToDelete) {
      final deleted = delete(record.id!);
      if (!deleted) {
        allDeleted = false;
      }
    }
    return allDeleted;
  }

  /// Sets (updates) the record in the storage with the given record object id.
  /// Return true = update ok, false = no record object with the given id found!
  ///
  bool set(Record record) {
    // Todo
    final recordindex =
        _records.indexWhere((existingRecord) => existingRecord.id == record.id);
    if (recordindex != -1) {
      _records[recordindex] = record;
      notifyListeners();
      return true;
    }
    return false;
  }

  /// Adds the given record object.
  /// Return true = persist ok, false = error record object not persisted!
  /// Side effects: record.id = nextId
  ///
  bool add(Record record) {
    // Todo

    record.id = _nextId;
    _records.add(record);
    notifyListeners();
    return true;
  }

  Future<void> loadRecordsFromSharedPrefs() async {
    final storage = SharedPreferencesAsync();
    final recordStrings = await storage.getStringList('records');
    if (recordStrings != null && recordStrings.isNotEmpty) {
      _records.addAll(recordStrings.map((r) => Record.fromJson(jsonDecode(r))));
    } else {
      // Optional: if empty add list with test records
      _records.addAll(testRecords);
    }
    addListener(
      () => storage.setStringList(
        'records',
        _records.map((e) => json.encode(e.toJson())).toList(),
      ),
    );
  }
}
