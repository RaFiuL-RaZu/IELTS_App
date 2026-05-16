class ActivityModel {
  final MonthlyActivity? monthlyActivity;
  final int? totalCallBack;
  final int? totalSubmitted;
  final int? totalBooked;
  final int? totalRejected;
  final int? totalAuditionCount;
  final int? thisMonthTotalBook;

  ActivityModel({
    this.monthlyActivity,
    this.totalCallBack,
    this.totalSubmitted,
    this.totalBooked,
    this.totalRejected,
    this.totalAuditionCount,
    this.thisMonthTotalBook,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      monthlyActivity: json['monthlyActivity'] != null
          ? MonthlyActivity.fromJson(json['monthlyActivity'])
          : null,
      totalCallBack: json['totalCallBack'] ?? 0,
      totalSubmitted: json['totalSubmitted'] ?? 0,
      totalBooked: json['totalBooked'] ?? 0,
      totalAuditionCount: json['totalAuditionCount'] ?? 0,
      totalRejected: json['totalRejected'] ?? 0,
      thisMonthTotalBook: json['thisMonthTotalBook'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'monthlyActivity': monthlyActivity?.toJson(),
      'totalCallBack': totalCallBack,
      'totalSubmitted': totalSubmitted,
      'totalBooked': totalBooked,
      'totalAuditionCount': totalAuditionCount,
      'totalRejected': totalRejected,
      'thisMonthTotalBook': thisMonthTotalBook,
    };
  }
}

class MonthlyActivity {
  final int? jan;
  final int? feb;
  final int? mar;
  final int? apr;
  final int? may;
  final int? jun;
  final int? jul;
  final int? aug;
  final int? sep;
  final int? oct;
  final int? nov;
  final int? dec;

  MonthlyActivity({
    this.jan,
    this.feb,
    this.mar,
    this.apr,
    this.may,
    this.jun,
    this.jul,
    this.aug,
    this.sep,
    this.oct,
    this.nov,
    this.dec,
  });

  factory MonthlyActivity.fromJson(Map<String, dynamic> json) {
    return MonthlyActivity(
      jan: json['jan'] ?? 0,
      feb: json['feb'] ?? 0,
      mar: json['mar'] ?? 0,
      apr: json['apr'] ?? 0,
      may: json['may'] ?? 0,
      jun: json['jun'] ?? 0,
      jul: json['jul'] ?? 0,
      aug: json['aug'] ?? 0,
      sep: json['sep'] ?? 0,
      oct: json['oct'] ?? 0,
      nov: json['nov'] ?? 0,
      dec: json['dec'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'jan': jan,
      'feb': feb,
      'mar': mar,
      'apr': apr,
      'may': may,
      'jun': jun,
      'jul': jul,
      'aug': aug,
      'sep': sep,
      'oct': oct,
      'nov': nov,
      'dec': dec,
    };
  }
}