import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/holiday_model.dart';
import '../../../../core/error/failures.dart';

class HolidayFirestoreDatasource {
  final FirebaseFirestore _firestore;

  HolidayFirestoreDatasource(this._firestore);

  CollectionReference get _holidays => _firestore.collection('holidays');

  Future<List<HolidayModel>> getHolidaysByYear(int year) async {
    try {
      final snapshot = await _holidays
          .where('year', isEqualTo: year)
          .get();
      final list = snapshot.docs
          .map((doc) => HolidayModel.fromJson(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      
      // Sort in memory to avoid needing a Firestore Composite Index
      list.sort((a, b) => a.date.compareTo(b.date));
      return list;
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<HolidayModel?> getHolidayByDate(DateTime date) async {
    try {
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(const Duration(days: 1));

      final snapshot = await _holidays
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('date', isLessThan: Timestamp.fromDate(end))
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;
      
      final doc = snapshot.docs.first;
      return HolidayModel.fromJson(doc.data() as Map<String, dynamic>, doc.id);
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<void> addHoliday(HolidayModel holiday) async {
    try {
      await _holidays.add(holiday.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<void> updateHoliday(HolidayModel holiday) async {
    try {
      await _holidays.doc(holiday.id).update(holiday.toJson());
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }

  Future<void> deleteHoliday(String id) async {
    try {
      await _holidays.doc(id).delete();
    } catch (e) {
      throw ServerFailure(e.toString());
    }
  }
}
