import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/calendar_events_provider.dart';
import '../../domain/entities/leave_entity.dart';
import '../../../holidays/domain/entities/holiday_entity.dart';

class LeaveCalendarPage extends ConsumerStatefulWidget {
  const LeaveCalendarPage({super.key});

  @override
  ConsumerState<LeaveCalendarPage> createState() => _LeaveCalendarPageState();
}

class _LeaveCalendarPageState extends ConsumerState<LeaveCalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if(Navigator.of(context).canPop()){
          Navigator.of(context).pop();
        }else{
          context.go('/home');
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
            onPressed: () => context.pop(),
          ),
          title: Text(
            'Calendar',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCalendarCard(),
                    SizedBox(height: 24.h),
                    _buildUpcomingSection(),
                    SizedBox(height: 80.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarCard() {
    final eventsMap = ref.watch(calendarEventsProvider);
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              final date = DateTime(day.year, day.month, day.day);
              return eventsMap[date] ?? [];
            },
            headerStyle: HeaderStyle(
              formatButtonVisible: false,
              titleCentered: false,
              leftChevronIcon: Icon(Icons.chevron_left, color: AppColors.textPrimary, size: 24.sp),
              rightChevronIcon: Icon(Icons.chevron_right, color: AppColors.textPrimary, size: 24.sp),
              titleTextStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return const SizedBox();
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: events.take(4).map((event) {
                    Color color = AppColors.primary;
                    if (event is LeaveEntity) {
                      if (event.status == 'pending') color = AppColors.pending;
                      if (event.status == 'rejected') color = AppColors.rejected;
                    } else if (event is HolidayEntity) {
                      color = Colors.blue; // Public Holiday / Poya indicator
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 1.5, vertical: 6.0),
                      width: 6.w,
                      height: 6.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                      ),
                    );
                  }).toList(),
                );
              },
            ),
            calendarStyle: CalendarStyle(
              todayDecoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.primarySubtle,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.primary),
              ),
              selectedTextStyle: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
              weekendTextStyle: const TextStyle(color: AppColors.rejected),
            ),
            daysOfWeekStyle: const DaysOfWeekStyle(
              weekdayStyle: TextStyle(color: AppColors.textSecondary),
              weekendStyle: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          Divider(height: 1, color: AppColors.borderLight),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Wrap(
              spacing: 12.w,
              runSpacing: 8.h,
              alignment: WrapAlignment.center,
              children: [
                _buildLegendItem(label: 'Approved', color: AppColors.primary, isOutline: false),
                _buildLegendItem(label: 'Pending', color: AppColors.pending, isOutline: false),
                _buildLegendItem(label: 'Rejected', color: AppColors.rejected, isOutline: false),
                _buildLegendItem(label: 'Holiday / Poya', color: Colors.blue, isOutline: false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required String label, required Color color, required bool isOutline}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8.w,
          height: 8.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isOutline ? color.withOpacity(0.2) : color,
            border: isOutline ? Border.all(color: color) : null,
          ),
        ),
        SizedBox(width: 6.w),
        Text(
          label,
          style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildUpcomingSection() {
    final upcoming = ref.watch(upcomingEventsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 6,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: upcoming.isEmpty 
              ? Padding(
                  padding: EdgeInsets.all(32.w),
                  child: Center(
                    child: Text(
                      'No upcoming events',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                )
              : Column(
                  children: upcoming.map((event) {
                    IconData icon = Icons.event;
                    Color iconColor = AppColors.primary;
                    Color iconBg = AppColors.primarySubtle;
                    String title = '';
                    String subtitle = '';
                    String displayDate = '';
                    String statusStr = '';
                    
                    if (event is LeaveEntity) {
                      icon = Icons.work_outline;
                      if (event.status == 'pending') {
                        iconColor = AppColors.pendingText;
                        iconBg = AppColors.pendingBackground;
                      } else if (event.status == 'rejected') {
                        iconColor = AppColors.rejected;
                        iconBg = AppColors.rejected.withOpacity(0.1);
                      }
                      title = event.leaveType;
                      statusStr = event.status[0].toUpperCase() + event.status.substring(1);
                      
                      final dateStr = DateFormat('MMM d').format(event.startDate);
                      final endStr = DateFormat('MMM d').format(event.endDate);
                      displayDate = event.startDate == event.endDate ? dateStr : '$dateStr - $endStr';
                      subtitle = '$displayDate • $statusStr';
                    } else if (event is HolidayEntity) {
                      final dynamic e = event;
                      icon = e.type.toLowerCase().contains('poya') ? Icons.nightlight_round : Icons.flag;
                      iconColor = Colors.blue;
                      iconBg = Colors.blue.withOpacity(0.1);
                      title = e.name;
                      statusStr = e.type;
                      displayDate = DateFormat('MMM d').format(e.date);
                      subtitle = '$displayDate • $statusStr';
                    }

                    return Column(
                      children: [
                        _buildListItem(
                          icon: icon,
                          iconColor: iconColor,
                          iconBg: iconBg,
                          title: title,
                          subtitle: subtitle,
                        ),
                        if (event != upcoming.last)
                          Divider(height: 1, color: AppColors.borderLight),
                      ],
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: iconColor, size: 20.w),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
