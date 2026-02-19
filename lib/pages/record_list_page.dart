import 'package:flutter/material.dart';
import '../models/record.dart';
import 'record_detail_page.dart';
import '../data/record_repo.dart';
import 'package:provider/provider.dart';
import '../models/statistic.dart';
import 'package:share_plus/share_plus.dart';
import 'ModulePicker_Page.dart';

class RecordListPage extends StatefulWidget {
   const RecordListPage({super.key}) ;
   
   @override
   State<RecordListPage> createState() => _RecordListPageState () ;

}


class _RecordListPageState extends State<RecordListPage> {
 
  final String title = 'My Records';

  /*static const snackBar = SnackBar(
    content: Text('Not implemented yet 🥲'),
    duration: Durations.long1,
  );*/
  
  bool iscabMode = false ; 
  List<Record> selectedRecords = [] ;

  void  activateCabMode ( Record record) {
    setState(() {
      iscabMode = true ; 
      selectedRecords.add(record) ;
    });
  }

  void deactivateCabMode () {
    setState(() {
      iscabMode = false ; 
      selectedRecords.clear() ;
    });
  }

  void toggleRecordSelection ( Record record) {
    setState(() {
      if ( selectedRecords.contains(record) ) {
        selectedRecords.remove(record) ;
        if ( selectedRecords.isEmpty ) {
          deactivateCabMode() ;
        }
      } else {
        selectedRecords.add(record) ;
      }
    });
  }

  @override
  Widget build(BuildContext context) {

    final recordRepo = Provider.of<RecordRepository>(context);
    final records = recordRepo.records;
    return Scaffold(
      appBar: iscabMode ?  
      AppBar(
        title: Text('${selectedRecords.length} selected'),
        elevation: 1,
        shadowColor: Theme.of(context).shadowColor,
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: 'Close selection',
          onPressed: () {
            deactivateCabMode() ;
          },
        ),
       

        actions:
         <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete selected records',
            onPressed: () async {
            final confirmed =    await  showDialog <bool>(
              context: context,
              builder: (context) {
              return AlertDialog(
                title: const Text('Delete Records'),
                content: Text('Are you sure you want to delete ${selectedRecords.length} selected records?'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false); // Close the dialog
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true); // Close the dialog
                    },
                    child: const Text('Delete'),
                  ),
                ],
              );
            });

            if ( confirmed == true ) {
             
              recordRepo.deleteList(selectedRecords) ;
               // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${selectedRecords.length} records deleted')
              )
              ) ;
              deactivateCabMode() ;
            
            }
              }
              
            
          ),
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Share selected records',
            onPressed: () {
              final recordDetails = selectedRecords.map((r) => 
                'Module: ${r.moduleName}, CRP: ${r.crp}, Grade: ${r.grade}%'
              ).join('\n');
              final ShareParams params = ShareParams(
                text: 'Here are my selected records:\n$recordDetails'
              );
              SharePlus.instance.share(params);
            },
          ),
        ],
      )
      : AppBar(
        title: Text(title),
        elevation: 1,
        shadowColor: Theme.of(context).shadowColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.bar_chart),
            tooltip: 'Open records statistic',
            onPressed: () {
              final statistic = Statistic(records);

              showDialog(
                context: context, 
                builder: (context) => AlertDialog(
                  title: const Text('Records Statistic'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Record count: ${statistic.recordCount}'),
                      Text('50% records: ${statistic.hwCount}'),
                      Text('Sum crp: ${statistic.sumCrp}'),
                      Text('Crp to end: ${statistic.crpToEnd}'),
                      Text('Average : ${statistic.averageGrade.toStringAsFixed(2)}%'),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Close'),
                    ),
                  ],  
                ),
              );
            },
             
              
          ),
        ],
      ),
      body: RecordListView(records: records , iscabMode: iscabMode, selectedRecords: selectedRecords, 
      toggleRecordSelection: toggleRecordSelection,activateCabMode:  activateCabMode),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
        await Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => ModulePickerPage(),
          ),   
        );
        }, 
        tooltip: 'Add record',
        child: const Icon(Icons.add),
      ),
    );
  }
}

class RecordListView extends StatelessWidget {
  const RecordListView({super.key, required this.records, 
   required this.iscabMode ,  required this.selectedRecords ,  required this.toggleRecordSelection, required this.activateCabMode}) ;

  final List<Record> records;
  final bool iscabMode ;
  final List<Record> selectedRecords ;
  final void Function(Record record) toggleRecordSelection ;
  final void  Function(Record record) activateCabMode ;

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
        final isSelected = selectedRecords.contains(r) ;
        return ListTile(
          contentPadding: const EdgeInsets.all(16.0),
          title: Text(
            '${r.moduleName} ${r.crp}Crp ${r.grade}%',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
          ),
          tileColor: isSelected ? const Color.fromARGB(255, 34, 122, 167) : null ,
          onLongPress: () => activateCabMode(r),
          onTap: iscabMode ? () => toggleRecordSelection(r) 
          :  () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RecordDetailPage(record: r),
              ),
            );
          },
        );
      },
      separatorBuilder: (_, __) => const Divider(),
      itemCount: records.length,
    );
    
  }
}

