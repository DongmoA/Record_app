import 'package:flutter_test/flutter_test.dart';
import 'package:records_app/data/record_repo.dart';
import 'package:records_app/data/record_test_data.dart';
import 'package:records_app/models/record.dart';

void main() {
  group('RecordRepository', () {
    RecordRepository? recordRepo;
    setUp(() {
      recordRepo = RecordRepository(testRecords);
    });
    // tearDown(() => {});
    test('Get all records', () {
      final records = recordRepo?.records;
      expect(records?.length, 4);
    });

    test('Add record', () async {
      final record = Record(
          moduleNumber: '4711',
          moduleName: 'TEST MODULE NAME',
          crp: 6,
          grade: 99,
          halfWeighted: true,
          summerTerm: true,
          year: 2018);
      final result = recordRepo?.add(record);
      expect(result, true);
      expect(record.id, 5);
      expect(recordRepo?.records.length, 5);
    });

    test('Set/update record', () async {
      var record = recordRepo?.records.first;
      expect(record != null, true);
      expect(record?.id, 1);
      record?.moduleNumber = 'TEST NUMBER';
      record?.moduleName = 'TEST NAME';
      final result = recordRepo?.set(record as Record);
      expect(result, true);
      record = recordRepo?.records.first;
      expect(record != null, true);
      expect(record?.id, 1);
      expect(record?.moduleNumber, 'TEST NUMBER');
      expect(record?.moduleName, 'TEST NAME');
    });

    test('delete record', () async {
      final record = recordRepo?.records.first;
      expect(record != null, true);
      expect(record?.id, 1);
      final result = recordRepo?.delete(record?.id ?? -1);
      expect(result, true);
      expect(recordRepo?.records.length, 3);
    });
  });
}
