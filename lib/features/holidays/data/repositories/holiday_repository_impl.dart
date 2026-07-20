import '../../domain/entities/holiday_entity.dart';
import '../../domain/repositories/holiday_repository.dart';
import '../datasources/holiday_firestore_datasource.dart';
import '../models/holiday_model.dart';

class HolidayRepositoryImpl implements HolidayRepository {
  final HolidayFirestoreDatasource _datasource;

  HolidayRepositoryImpl(this._datasource);

  @override
  Future<List<HolidayEntity>> getHolidaysByYear(int year) async {
    return await _datasource.getHolidaysByYear(year);
  }

  @override
  Future<HolidayEntity?> getHolidayByDate(DateTime date) async {
    return await _datasource.getHolidayByDate(date);
  }

  @override
  Future<void> addHoliday(HolidayEntity holiday) async {
    final model = HolidayModel.fromEntity(holiday);
    await _datasource.addHoliday(model);
  }

  @override
  Future<void> updateHoliday(HolidayEntity holiday) async {
    final model = HolidayModel.fromEntity(holiday);
    await _datasource.updateHoliday(model);
  }

  @override
  Future<void> deleteHoliday(String id) async {
    await _datasource.deleteHoliday(id);
  }
}
