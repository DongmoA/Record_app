import 'package:flutter/material.dart';
import 'pages/record_list_page.dart';

void main() {
  runApp(const RecordApp());
}

class RecordApp extends StatelessWidget {
  const RecordApp({super.key});
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Remove the debug banner
      debugShowCheckedModeBanner: false,
      title: 'My Records App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const RecordListPage(),
    );
  }
}
