class Record {
  //  implement Record
  int ? id;
  String ? moduleNumber;
  String ? moduleName;
  int ? crp;
  int ? grade;
  bool ? halfWeighted;
  bool ? summerTerm;
  int ? year;
  Record({
     this.id,
     this.moduleNumber,
     this.moduleName,
     this.crp,
     this.grade,
     this.halfWeighted = false,
     this.summerTerm = false,
     this.year,
  });

static  Record fromJson (Map<String, dynamic> json) {
    return Record(
      id: json['id'],
      moduleNumber: json['moduleNumber'],
      moduleName: json['moduleName'],
      crp: json['crp'],
      grade: json['grade'],
      halfWeighted: json['halfWeighted'],
      summerTerm: json['summerTerm'],
      year: json['year'],
    );
  }

 Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moduleNumber': moduleNumber,
      'moduleName': moduleName,
      'crp': crp,
      'grade': grade,
      'halfWeighted': halfWeighted,
      'summerTerm': summerTerm,
      'year': year,
    };
  }  

Record copy() {
    return Record(
      id: id,
      moduleNumber: moduleNumber,
      moduleName: moduleName,
      crp: crp,
      grade: grade,
      halfWeighted: halfWeighted,
      summerTerm: summerTerm,
      year: year,
    );
  }

 
}
