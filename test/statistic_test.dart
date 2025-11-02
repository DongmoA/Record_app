import 'package:flutter_test/flutter_test.dart';
import 'package:records_app/models/statistic.dart';

import 'package:records_app/data/record_test_data.dart';

void main() {
  // This group tests your records Statistic class!

  final statsNoRecords = Statistic([]);
  final stats2Records = Statistic(testRecords.take(2).toList());
  final stats4Records = Statistic(testRecords);

  group('Statistic', () {
    test('Records should be counted', () {
      expect(statsNoRecords.recordCount, 0);
      expect(stats2Records.recordCount, 2);
      expect(stats4Records.recordCount, 4);
    });

    test('Half weighted records should be counted', () {
      expect(statsNoRecords.hwCount, 0);
      expect(stats2Records.hwCount, 2);
      expect(stats4Records.hwCount, 2);
    });

    test('Credit points should be summed up', () {
      expect(statsNoRecords.sumCrp, 0);
      expect(stats2Records.sumCrp, 12);
      expect(stats4Records.sumCrp, 24);
    });

    test('Missing credit points to graduation should be calculated', () {
      expect(statsNoRecords.crpToEnd, 180);
      expect(stats2Records.crpToEnd, 168);
      expect(stats4Records.crpToEnd, 156);
    });

    test('Average grade should be calculated', () {
      expect(statsNoRecords.averageGrade, 0);
      expect(stats2Records.averageGrade, 77);
      expect(stats4Records.averageGrade, 83);
    });
  });
}
