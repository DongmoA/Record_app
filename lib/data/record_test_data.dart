import '../models/record.dart';

final testRecords = [
  Record(
      id: 1,
      moduleNumber: 'CS1013',
      moduleName: 'Objektorientierte Programmierung',
      crp: 6,
      grade: 73,
      halfWeighted: true,
      summerTerm: true,
      year: 2020),
  Record(
      id: 2,
      moduleNumber: 'MN1007',
      moduleName: 'Diskrete Mathematik',
      crp: 6,
      grade: 81,
      halfWeighted: true,
      summerTerm: false,
      year: 2020),
  Record(
      id: 3,
      moduleNumber: 'CS1019',
      moduleName: 'Compilerbau',
      crp: 6,
      grade: 81,
      halfWeighted: false,
      summerTerm: false,
      year: 2021),
  Record(
      id: 4,
      moduleNumber: 'CS1020',
      moduleName: 'Datenbanksysteme',
      crp: 6,
      grade: 92,
      halfWeighted: false,
      summerTerm: false,
      year: 2021),
];
