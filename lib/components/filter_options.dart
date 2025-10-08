class FilterOptions {
  DateTime? startDate;
  DateTime? endDate;
  String category;

  FilterOptions({this.startDate, this.endDate, this.category = 'Given'});

  void reset() {
    startDate = null;
    endDate = null;
    category = 'Given';
  }

  bool isWithinRange(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    if (startDate != null) {
      final s = DateTime(startDate!.year, startDate!.month, startDate!.day);
      if (d.isBefore(s)) return false;
    }
    if (endDate != null) {
      final e = DateTime(endDate!.year, endDate!.month, endDate!.day);
      if (d.isAfter(e)) return false;
    }
    return true;
  }
}
