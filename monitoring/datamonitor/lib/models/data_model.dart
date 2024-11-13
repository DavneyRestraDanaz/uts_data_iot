// models/data_model.dart
class DataModel {
  final int suhumax;
  final int suhumin;
  final double suhurata;
  final List<SuhuHumidMax> nilaiSuhuMaxHumidMax;
  final List<MonthYearMax> monthYearMax;

  DataModel({
    required this.suhumax,
    required this.suhumin,
    required this.suhurata,
    required this.nilaiSuhuMaxHumidMax,
    required this.monthYearMax,
  });

  factory DataModel.fromJson(Map<String, dynamic> json) {
    var list = json['nilai_suhu_max_humid_max'] as List;
    List<SuhuHumidMax> suhuHumidList =
        list.map((i) => SuhuHumidMax.fromJson(i)).toList();

    var monthYearList = json['month_year_max'] as List;
    List<MonthYearMax> monthYearMaxList =
        monthYearList.map((i) => MonthYearMax.fromJson(i)).toList();

    return DataModel(
      suhumax: json['suhumax'],
      suhumin: json['suhumin'],
      suhurata: json['suhurata'],
      nilaiSuhuMaxHumidMax: suhuHumidList,
      monthYearMax: monthYearMaxList,
    );
  }
}

class SuhuHumidMax {
  final int idx;
  final int suhu;
  final int humid;
  final int kecerahan;
  final String timestamp;

  SuhuHumidMax({
    required this.idx,
    required this.suhu,
    required this.humid,
    required this.kecerahan,
    required this.timestamp,
  });

  factory SuhuHumidMax.fromJson(Map<String, dynamic> json) {
    return SuhuHumidMax(
      idx: json['idx'],
      suhu: json['suhu'],
      humid: json['humid'],
      kecerahan: json['kecerahan'],
      timestamp: json['timestamp'],
    );
  }
}

class MonthYearMax {
  final String monthYear;

  MonthYearMax({required this.monthYear});

  factory MonthYearMax.fromJson(Map<String, dynamic> json) {
    return MonthYearMax(
      monthYear: json['month_year'],
    );
  }
}
