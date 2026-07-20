import '../entities/holiday_entity.dart';

abstract class HolidayRepository {
  Future<List<HolidayEntity>> getHolidaysByYear(int year);
  Future<HolidayEntity?> getHolidayByDate(DateTime date);
  Future<void> addHoliday(HolidayEntity holiday);
  Future<void> updateHoliday(HolidayEntity holiday);
  Future<void> deleteHoliday(String id);
}
