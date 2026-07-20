import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/holiday_entity.dart';
import '../../domain/repositories/holiday_repository.dart';
import '../../data/datasources/holiday_firestore_datasource.dart';
import '../../data/repositories/holiday_repository_impl.dart';

part 'holiday_providers.g.dart';

@riverpod
HolidayFirestoreDatasource holidayRemoteDatasource(Ref ref) {
  return HolidayFirestoreDatasource(FirebaseFirestore.instance);
}

@riverpod
HolidayRepository holidayRepository(Ref ref) {
  return HolidayRepositoryImpl(ref.watch(holidayRemoteDatasourceProvider));
}

@riverpod
Future<List<HolidayEntity>> currentYearHolidays(Ref ref) {
  final currentYear = DateTime.now().year;
  return ref.watch(holidayRepositoryProvider).getHolidaysByYear(currentYear);
}

@riverpod
Future<List<HolidayEntity>> holidaysByYear(Ref ref, int year) {
  return ref.watch(holidayRepositoryProvider).getHolidaysByYear(year);
}

@riverpod
Future<HolidayEntity?> holidayByDate(Ref ref, DateTime date) {
  return ref.watch(holidayRepositoryProvider).getHolidayByDate(date);
}
