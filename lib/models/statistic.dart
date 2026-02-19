import 'record.dart';

class Statistic {
  int recordCount = 0;
  int hwCount = 0;
  int sumCrp = 0;
  int crpToEnd = 180;
  double averageGrade = 0; // Data type double benötigt für Durchschnittswerte

  Statistic(List<Record> records) {
    recordCount = records.length;
    hwCount = records.where((record) => record.halfWeighted == true).length;
    sumCrp = records.fold(0, (sum, record) => sum + (record.crp ?? 0));
    crpToEnd = 180 - sumCrp;
    
    if (recordCount > 0) {
      // gewichteten Notendurchschnitt berechnen
      double totalWeightedGrade = records.fold(0.0, (sum, record) {
       final grade = record.grade ?? 0;
       final halfWeighted = record.halfWeighted ?? false;
       final crp = record.crp ?? 0;
       return sum + (grade * (halfWeighted ? crp / 2 : crp));  
        });
      averageGrade = (totalWeightedGrade / records.fold(0.0, (sum , records) {
        final crp = records.crp ?? 0;
        final halfWeighted = records.halfWeighted ?? false;
        return  sum + (halfWeighted ? crp / 2 : crp);
    })).round().toDouble();
      averageGrade.ceil(); 
    } else {
      averageGrade = 0.0;
    }
  }
}