class Report {
  String shortCut;
  String title;
  ReportType reportType;
  Report(this.shortCut, this.title, this.reportType);
}

class ReportRepo {
  static List<Report> repo = [
    Report('EXP-YTD', 'Expenses Year-to-Date', ReportType.pie),
    Report('INC-YTD', 'Income Year-to-Date', ReportType.pie),
    Report('CAT-YTD-UTILITIES', 'Utilities Year-to-Date', ReportType.pie),
    Report('BA-EXP-MTD', 'Budget Vs Actual Month-to-Date', ReportType.bar),
  ];
}

enum ReportType { pie, bar }
