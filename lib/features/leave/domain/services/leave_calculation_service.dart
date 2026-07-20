import 'package:leave_management_app/features/holidays/domain/entities/holiday_entity.dart';

class LeaveCalculationService {
  /// Calculates the number of working days between [startDate] and [endDate] (inclusive).
  /// Excludes Saturdays, Sundays, and any dates that match [holidays].
  /// If [isHalfDay] is true, it returns 0.5 only if the start date is a working day, otherwise 0.
  static double calculateWorkingDays(
    DateTime startDate,
    DateTime endDate,
    bool isHalfDay,
    List<HolidayEntity> holidays,
  ) {
    if (startDate.isAfter(endDate)) {
      return 0.0;
    }

    // Strip time from dates to ensure accurate comparison
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day);
    
    // Create a set of holiday dates for fast lookup
    final holidayDates = holidays.map((h) => DateTime(h.date.year, h.date.month, h.date.day)).toSet();

    double totalDays = 0.0;
    DateTime current = start;

    while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
      final isWeekend = current.weekday == DateTime.saturday || current.weekday == DateTime.sunday;
      final isHoliday = holidayDates.contains(current);

      if (!isWeekend && !isHoliday) {
        totalDays += 1.0;
      }

      current = current.add(const Duration(days: 1));
    }

    if (isHalfDay) {
      // If they requested a half day on a weekend/holiday, it's 0 working days.
      return totalDays > 0 ? 0.5 : 0.0;
    }

    return totalDays;
  }
}
