import 'record.dart';

class Statistic {
  int recordCount = 0;
  int hwCount = 0;
  int sumCrp = 0;
  int crpToEnd = 180;
  double averageGrade = 0; // Data type double benötigt für Durchschnittswerte

  Statistic(List<Record> records) {
    recordCount = records.length;
    hwCount = records.where((record) => record.halfWeighted).length;
    sumCrp = records.fold(0, (sum, record) => sum + record.crp);
    crpToEnd = 180 - sumCrp;
    
    if (recordCount > 0) {
      // gewichteten Notendurchschnitt berechnen
      double totalWeightedGrade = records.fold(0.0, (sum, record) => 
        sum + (record.grade * (record.halfWeighted ?  record.crp /2 : record.crp)));
      averageGrade = (totalWeightedGrade / records.fold(0.0, (sum , records)=> 
        sum + (records.halfWeighted ? records.crp /2 : records.crp))).round().toDouble();
      averageGrade.ceil(); 
    } else {
      averageGrade = 0.0;
    }
  }
}