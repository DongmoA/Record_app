import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../data/record_repo.dart';

import '../models/record.dart';

class RecordDetailPage extends StatelessWidget {
  RecordDetailPage({super.key, Record? record})
    : _record = record == null
          ? Record(year: DateTime.now().year)
          : record.copy(),
      _isEditMode = record != null;

  final Record _record;
  final bool _isEditMode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Record' : 'Create Record'),
        elevation: 1,
        shadowColor: Theme.of(context).shadowColor,
        actions: <Widget>[
          if (_isEditMode)
            IconButton(
              icon: const Icon(Icons.delete),
              tooltip: 'Delete Record',
              onPressed: () async {
                // Todo
               final confirmed = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Record'),
                    content: const Text('Are you sure you want to delete this record?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                ) ?? false;
                if ( confirmed == true && _record.id != null) {
                  if(!context.mounted) return;
                  final recordRepo = Provider.of<RecordRepository>(context, listen: false);
                  recordRepo.delete(_record.id!);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                }
               

              },
            ),
        ],
      ),
      body: SingleChildScrollView(child: RecordForm(_record)),
    );
  }
}

class RecordForm extends StatefulWidget {
  const RecordForm(this._record, {super.key});
  final Record _record;

  @override
  RecordFormState createState() => RecordFormState();
}

class RecordFormState extends State<RecordForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  final _yearsDropdownMenuEntries = List.generate(10, (index) {
    final year = DateTime.now().year - index;
    return DropdownMenuEntry<int>(value: year, label: year.toString());
  });

  @override
  Widget build(BuildContext context) {
    final record = widget._record;
    debugPrint('${record.id} ${record.moduleName}' );

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
            <Widget>[
                  TextFormField(
                    initialValue: record.moduleNumber,
                    keyboardType: TextInputType.text,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Modul number*',
                    ),
                    autofocus: record.id == null ? true : false,
                    // The validator receives the text that the user has entered.
                    validator: (value) {
                      // Todo
                      if (value == null || value.isEmpty) {
                        return 'Please enter a module number';
                      }
                      return null;
                    },
                    onSaved: (newValue) => record.moduleNumber = newValue,
                  ),
                  TextFormField(
                    initialValue: record.moduleName,
                    keyboardType: TextInputType.text,
                    inputFormatters: <TextInputFormatter>[
                      LengthLimitingTextInputFormatter(100),
                    ],
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Modul name*',
                    ),
                    validator: (value) {
                      // Todo
                      if (value == null || value.isEmpty) {
                        return 'Please enter a module name';
                      }

                      return null;
                    },
                    onSaved: (newValue) => record.moduleName = newValue,
                  ),
                  CheckboxListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text('Summer term'),
                    value: record.summerTerm,
                    onChanged: (value) => setState(() {
                      record.summerTerm = value ?? false;
                    }),
                  ),
                  const Divider(height: 0, thickness: 2),
                  ListTile(
                    title: const Text('Year'),
                    contentPadding: const EdgeInsets.all(0),
                    trailing: DropdownMenu<int>(
                      dropdownMenuEntries: _yearsDropdownMenuEntries,
                      textStyle: Theme.of(context).textTheme.titleMedium,
                      inputDecorationTheme: const InputDecorationTheme(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      initialSelection:
                          record.year ?? _yearsDropdownMenuEntries[0].value,
                      onSelected: (value) => record.year = value,
                    ),
                  ),
                  const Divider(height: 0, thickness: 2),
                  TextFormField(
                    initialValue: record.crp?.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Credit points*',
                    ),
                    validator: (value) {
                      // Todo
                      if (value == null || value.isEmpty) {
                        return 'Please enter credit points';
                      }
                      final  cp = int.tryParse(value);
                      if (cp == null || cp <= 0 || cp > 15) {
                        return 'Please enter a valid number of credit points';
                      }

                      return null;
                    },
                    onSaved: (newValue) =>
                        record.crp = int.tryParse(newValue ?? ''),
                  ),
                  TextFormField(
                    initialValue: record.grade?.toString(),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(3),
                    ],
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Grade',
                    ),
                    validator: (value) {
                      // Todo
                      if (value == null || value.isEmpty) {
                        return null;
                      }
                      final grade = int.tryParse(value);
                      if (grade == null || grade < 50 || grade > 100) {
                        return 'Please enter a valid grade between 50 and 100';
                      }
                      return null;
                    },
                    onSaved: (newValue) =>
                        record.grade = int.tryParse(newValue ?? ''),
                  ),
                  CheckboxListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: const Text('50% weighted'),
                    value: record.halfWeighted,
                    onChanged: (value) => setState(() {
                      record.halfWeighted = value ?? false;
                    }),
                  ),
                  const Divider(height: 0, thickness: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        textAlign: TextAlign.start,
                        '*mandatory',
                        style: TextStyle(color: Colors.grey),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            // Todo
                            _formKey.currentState!.save();
                            final recordRepo = Provider.of<RecordRepository>(context, listen: false);
                            if (record.id == null) {
                              // New record
                              recordRepo.add(record);
                            } else {
                              // Existing record
                              recordRepo.set(record);
                            }
                            Navigator.of(context).pop();

                            
                          }
                        },
                        child: const Text('Submit'),
                      ),
                    ],
                  ),
                ]
                .map(
                  (widget) => Padding(
                    padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
                    child: widget,
                  ),
                )
                .toList(),
      ),
    );
  }
}
