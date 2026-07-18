import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management_app/features/school/presentation/providers/school_providers.dart';
import 'package:leave_management_app/features/leave/presentation/providers/leave_providers.dart';
import 'package:leave_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:leave_management_app/features/leave/domain/entities/leave_entity.dart';

class ReportsPage extends ConsumerWidget {
  const ReportsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schoolAsync = ref.watch(currentSchoolProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Reports',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: AppColors.textPrimary),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  schoolAsync.when(
                    data: (school) {
                      if (school == null) return const Center(child: Text('School not found'));
                      
                      final usersAsync = ref.watch(schoolUsersProvider(school.id));
                      final leavesAsync = ref.watch(allLeavesProvider(school.id));

                      return usersAsync.when(
                        data: (users) {
                          return leavesAsync.when(
                            data: (leaves) {
                              return Column(
                                children: [
                                  _buildUsageCard(school.leavePolicies, users, leaves),
                                  SizedBox(height: 24.h),
                                  _buildTopTakersSection(users, leaves),
                                ],
                              );
                            },
                            loading: () => const Center(child: CircularProgressIndicator()),
                            error: (err, _) => Center(child: Text('Error loading leaves: $err')),
                          );
                        },
                        loading: () => const Center(child: CircularProgressIndicator()),
                        error: (err, _) => Center(child: Text('Error loading users: $err')),
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(child: Text('Error: $err')),
                  ),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageCard(Map<String, int> leavePolicies, List<UserEntity> users, List<LeaveEntity> leaves) {
    final activeUsersCount = users.where((u) => !u.isPending).length;

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
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Team Quotas',
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          SizedBox(height: 20.h),
          ...leavePolicies.entries.map((e) {
            final leaveType = e.key;
            final quotaPerPerson = e.value;
            final totalCapacity = activeUsersCount * quotaPerPerson;
            
            final currentYear = DateTime.now().year;
            final usedDays = leaves
                .where((l) => l.leaveType == leaveType && l.startDate.year == currentYear && l.status == 'approved')
                .fold(0.0, (sum, l) => sum + l.durationDays);

            final percent = totalCapacity > 0 ? (usedDays / totalCapacity).clamp(0.0, 1.0) : 0.0;

            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildProgressBar(
                leaveType, 
                quotaPerPerson > 0 ? '${usedDays.toStringAsFixed(1).replaceAll(RegExp(r'\\.0$'), '')} / $totalCapacity Days' : 'No Quota', 
                percent,
                AppColors.primary
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProgressBar(String label, String value, double percent, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: AppColors.textSecondary, fontSize: 13.sp)),
            Text(value, style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13.sp)),
          ],
        ),
        SizedBox(height: 8.h),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: AppColors.scaffoldBackground,
          color: color,
          minHeight: 8.h,
          borderRadius: BorderRadius.circular(4.r),
        ),
      ],
    );
  }

  Widget _buildTopTakersSection(List<UserEntity> users, List<LeaveEntity> leaves) {
    final currentYear = DateTime.now().year;
    
    final Map<String, double> userLeaveTotals = {};
    for (final leave in leaves) {
      if (leave.startDate.year == currentYear && leave.status == 'approved') {
        userLeaveTotals[leave.userId] = (userLeaveTotals[leave.userId] ?? 0.0) + leave.durationDays;
      }
    }

    final sortedEntries = userLeaveTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    final topTakers = sortedEntries.take(3).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Leave Takers',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        if (topTakers.isEmpty)
          const Text('No leaves taken this year.', style: TextStyle(color: AppColors.textSecondary))
        else
          Container(
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
                for (var i = 0; i < topTakers.length; i++) ...[
                  if (i > 0) Divider(height: 1, color: AppColors.borderLight),
                  Builder(builder: (context) {
                    final entry = topTakers[i];
                    final user = users.firstWhere(
                      (u) => u.id == entry.key, 
                      orElse: () => UserEntity(
                        id: entry.key,
                        email: '',
                        schoolId: '',
                        fullName: 'Unknown User',
                        role: 'employee',
                      )
                    );
                    
                    final colors = [const Color(0xFFF43F5E), const Color(0xFFF59E0B), const Color(0xFF0EA5E9)];
                    final avatarColor = colors[i % colors.length];

                    return _buildTopTakerItem(
                      avatar: user.initials,
                      avatarColor: avatarColor,
                      name: user.fullName,
                      role: _formatRole(user.role),
                      days: entry.value.toStringAsFixed(1).replaceAll(RegExp(r'\\.0$'), ''),
                    );
                  }),
                ],
              ],
            ),
          ),
      ],
    );
  }

  String _formatRole(String role) {
    if (role == 'school_admin') return 'School Admin';
    if (role == 'super_admin') return 'Super Admin';
    if (role == 'manager') return 'Manager';
    return 'Employee';
  }

  Widget _buildTopTakerItem({
    required String avatar,
    required Color avatarColor,
    required String name,
    required String role,
    required String days,
  }) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: avatarColor,
            radius: 20.r,
            child: Text(
              avatar,
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  role,
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                days,
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              Text(
                'Days',
                style: TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
