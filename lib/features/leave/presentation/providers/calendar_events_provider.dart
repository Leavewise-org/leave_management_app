import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/leave_entity.dart';
import 'leave_providers.dart';
import '../../../holidays/presentation/providers/holiday_providers.dart';
import '../../../holidays/domain/entities/holiday_entity.dart';

part 'calendar_events_provider.g.dart';

@riverpod
Stream<List<LeaveEntity>> currentUserLeaves(Ref ref) {
  final userAsync = ref.watch(authStateProvider);
  final userId = userAsync.valueOrNull?.id;
  
  if (userId == null) {
    return Stream.value([]);
  }
  
  return ref.watch(leaveRepositoryProvider).getUserLeaves(userId);
}

@riverpod
Map<DateTime, List<dynamic>> calendarEvents(Ref ref) {
  final leavesAsync = ref.watch(currentUserLeavesProvider);
  final holidaysAsync = ref.watch(currentYearHolidaysProvider);
  
  final Map<DateTime, List<dynamic>> map = {};
  
  // Add leaves
  if (leavesAsync.valueOrNull != null) {
    for (final leave in leavesAsync.value!) {
      DateTime current = DateTime(leave.startDate.year, leave.startDate.month, leave.startDate.day);
      final end = DateTime(leave.endDate.year, leave.endDate.month, leave.endDate.day);
      
      while (current.isBefore(end) || current.isAtSameMomentAs(end)) {
        if (map[current] == null) {
          map[current] = [];
        }
        map[current]!.add(leave);
        current = current.add(const Duration(days: 1));
      }
    }
  }

  // Add holidays
  if (holidaysAsync.valueOrNull != null) {
    for (final holiday in holidaysAsync.value!) {
      DateTime date = DateTime(holiday.date.year, holiday.date.month, holiday.date.day);
      if (map[date] == null) {
        map[date] = [];
      }
      map[date]!.add(holiday);
    }
  }
  
  return map;
}

@riverpod
List<dynamic> upcomingEvents(Ref ref) {
  final leavesAsync = ref.watch(currentUserLeavesProvider);
  final holidaysAsync = ref.watch(currentYearHolidaysProvider);
  
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  
  List<dynamic> upcoming = [];

  // Add upcoming leaves
  if (leavesAsync.valueOrNull != null) {
    upcoming.addAll(leavesAsync.value!.where((leave) {
      final end = DateTime(leave.endDate.year, leave.endDate.month, leave.endDate.day);
      return end.isAfter(today) || end.isAtSameMomentAs(today);
    }));
  }

  // Add upcoming holidays
  if (holidaysAsync.valueOrNull != null) {
    upcoming.addAll(holidaysAsync.value!.where((holiday) {
      final date = DateTime(holiday.date.year, holiday.date.month, holiday.date.day);
      return date.isAfter(today) || date.isAtSameMomentAs(today);
    }));
  }
  
  // Sort by date (assuming dynamic objects have startDate or date)
  upcoming.sort((a, b) {
    DateTime aDate = a is LeaveEntity ? a.startDate : (a as HolidayEntity).date;
    DateTime bDate = b is LeaveEntity ? b.startDate : (b as HolidayEntity).date;
    return aDate.compareTo(bDate);
  });
  
  return upcoming;
}
