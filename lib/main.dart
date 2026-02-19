import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/record_list_page.dart';
import 'data/record_repo.dart';
import 'pages/ModulePicker_Page.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final recordRepo = RecordRepository();
  await recordRepo.loadRecordsFromSharedPrefs();

  final moduleRepo = ModuleRepository(); 
  await moduleRepo.loadModules();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: recordRepo),
        ChangeNotifierProvider.value(value: moduleRepo),
      ],
      child: RecordApp(recordRepo: recordRepo),
    ),
  );
}

class RecordApp extends StatelessWidget {
  const RecordApp({super.key, required this.recordRepo});
  final RecordRepository recordRepo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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