import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:records_app/pages/record_list_page.dart';
import 'package:records_app/models/record.dart';

import 'package:records_app/data/record_test_data.dart';

void main() {
  // This group tests your RecordListView widget!

  group('RecordListView', () {
    testWidgets('should be empty and shows a hint',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp([]));
      // Records are empty so there is no ListView
      expect(find.byType(ListView), findsNothing);
      // Is hint text shown?
      expect(find.byKey(const Key('no_records_hint')), findsOneWidget);
    });
    testWidgets('has records and shows list items',
        (WidgetTester tester) async {
      await tester.pumpWidget(createTestApp(testRecords));
      // Records are not empty and ListView is shown
      expect(find.byType(ListView), findsOneWidget);
      // Hint text is not shown?
      expect(find.byKey(const Key('no_records_hint')), findsNothing);
    });
  });
}

Widget createTestApp(List<Record> records) {
  return MaterialApp(
    home: Scaffold(
      body: RecordListView(
        records: records,
        iscabMode: false,
        selectedRecords: [],
        toggleRecordSelection: (Record record) {},
        activateCabMode: (Record record) {},
        
      ),
    ),
  );
}
