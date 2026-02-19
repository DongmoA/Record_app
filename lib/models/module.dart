import '../models/record.dart';

class Module {
  final String number;
  final String name;
  final int crp; 

  Module({required this.number, required this.name, required this.crp});
 
  static Module fromJson(Map<String, dynamic> json) {
    return Module(
      number: json['number'],
      name: json['name'],
      crp: json['crp'],
    );
  }

  Record toRecord() {
    return Record(
      moduleNumber: number,
      moduleName:name ,
      crp: crp,
    );
  }

}