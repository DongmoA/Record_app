import 'package:flutter/material.dart';
import '../models/record.dart';
import '../models/statistic.dart';
import '../data/record_test_data.dart';

class RecordListPage extends StatefulWidget {
   const RecordListPage({super.key}) ;
   
   @override
   State<RecordListPage> createState() => _RecordListPageState () ;

}


class _RecordListPageState extends State<RecordListPage> {
 
  final String title = 'My Records';
  List<Record> records = []; // Initial empty list of records

 /* static const snackBar = SnackBar(
    content: Text('Not implemented yet 🥲'),
    duration: Durations.long1,
  );*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 1,
        shadowColor: Theme.of(context).shadowColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Open records statistic',
            onPressed: () =>
              //  ScaffoldMessenger.of(context).showSnackBar(snackBar),
              showStatisticsDialog(context, records)
          ),
        ],
      ),
      body: RecordListView(records: records),
      floatingActionButton: FloatingActionButton(
       // onPressed: () => ScaffoldMessenger.of(context).showSnackBar(snackBar),
       onPressed: () async {
       var result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  AddRecordPage()),
         );
        if (result != null) {
          setState(() {
            records.add(result) ;
          });
        }
       },
        
        tooltip: 'Add record',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RecordListView extends StatelessWidget {
  const RecordListView({super.key, required this.records});

  final List<Record> records;

  @override
  Widget build(BuildContext context) {
    // implement ListView
    if (records.isEmpty) {
    return const Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 8),
              Center(
                child: Text(
                  key: Key('no_records_hint'),
                  'Unfortunately you don\'t have any records yet 😢!',
                ),
              ),
            ],
          );
  }
   
 return ListView.separated(
  itemBuilder: (context, index) {
    final r = records[index];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              r.moduleName,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              r.moduleNumber,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${r.crp}',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${r.grade}',
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  },
  separatorBuilder: (_, __) => const Divider(),
  itemCount: records.length,
);

    
  }
}



class AddRecordPage extends StatefulWidget {
  const AddRecordPage({super.key});

  @override
  State<AddRecordPage> createState() => _AddRecordPageState();
}

// Classe LabeledTextField modifiée
class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String text;
  final TextInputType keyboardType;
  
  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.text = '',
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: SizedBox(
            height: 45,
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: text,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// Classe _AddRecordPageState modifiée
class _AddRecordPageState extends State<AddRecordPage> {
  var moduleNumberController = TextEditingController();
  var moduleNameController = TextEditingController();
  var idController = TextEditingController();
  var crpController = TextEditingController();
  var gradeController = TextEditingController();
  bool halfWeighted = false;
  bool summerTerm = false;
  int year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leistungen anlegen'),
        elevation: 1,
        shadowColor: Theme.of(context).shadowColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  LabeledTextField(
                    label: 'ID:',
                    controller: idController,
                    text: 'z.B. 1',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  LabeledTextField(
                    label: 'Modulnummer:',
                    controller: moduleNumberController,
                    text: 'z.B. INF1234',
                  ),
                  const SizedBox(height: 16),
                  LabeledTextField(
                    label: 'Modulname:',
                    controller: moduleNameController,
                    text: 'z.B. Einführung in die Informatik',
                  ),
                  const SizedBox(height: 16),
                  LabeledTextField(
                    label: 'Credit Points:',
                    controller: crpController,
                    text: 'z.B. 6',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  LabeledTextField(
                    label: 'Note:',
                    controller: gradeController,
                    text: 'z.B. 85',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 140,
                        child: Text(
                          'Halb gewichtet:',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SwitchListTile(
                            title: null,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            value: halfWeighted,
                            onChanged: (bool value) {
                              setState(() {
                                halfWeighted = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 140,
                        child: Text(
                          'Sommersemester:',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: SwitchListTile(
                            title: null,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
                            value: summerTerm,
                            onChanged: (bool value) {
                              setState(() {
                                summerTerm = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        width: 140,
                        child: Text(
                          'Jahr:',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 45,
                          child: DropdownButtonFormField<int>(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                            initialValue: year,
                            items: List.generate(10, (index) => 2020 + index)
                                .map((year) => DropdownMenuItem(
                                      value: year,
                                      child: Text(year.toString()),
                                    ))
                                .toList(),
                            onChanged: (int? newValue) {
                              setState(() {
                                year = newValue!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () {
                  Record newRecord = Record(
                    id: int.parse(idController.text),
                    moduleNumber: moduleNumberController.text,
                    moduleName: moduleNameController.text,
                    crp: int.parse(crpController.text),
                    grade: int.parse(gradeController.text),
                    halfWeighted: halfWeighted,
                    summerTerm: summerTerm,
                    year: year,
                  );
                  Navigator.pop(context, newRecord);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Leistung speichern',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

// for static analysis 

void showStatisticsDialog(BuildContext context, List<Record> records) {
  final stats = Statistic(records);
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Titre
              const Text(
                'Statistik',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              // Tableau des statistiques
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    _buildStatRow(
                      'Anzahl erfasster Leistungen',
                      '${stats.recordCount}',
                      isFirst: true,
                    ),
                    _buildStatRow(
                      'Anzahl 50% Leistungen',
                      '${stats.hwCount}',
                    ),
                    _buildStatRow(
                      'Summe CrP',
                      '${stats.sumCrp}',
                    ),
                    _buildStatRow(
                      'CrP bis zum Abschluss',
                      '${stats.crpToEnd}',
                    ),
                    _buildStatRow(
                      'Durchschnittsnote',
                      '${stats.averageGrade}',
                      isLast: true,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Bouton de fermeture
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Schließen'),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildStatRow(String label, String value, {bool isFirst = false, bool isLast = false}) {
  return Container(
    decoration: BoxDecoration(
      border: Border(
        bottom: isLast ? BorderSide.none : BorderSide(color: Colors.grey.shade300),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ],
      ),
    ),
  );
}
