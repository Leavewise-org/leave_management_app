import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management_app/features/school/presentation/providers/school_providers.dart';

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
                      return _buildUsageCard(school.leavePolicies);
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (err, _) => Center(child: Text('Error: $err')),
                  ),
                  SizedBox(height: 24.h),
                  _buildTopTakersSection(),
                  SizedBox(height: 80.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUsageCard(Map<String, int> leavePolicies) {
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
            return Padding(
              padding: EdgeInsets.only(bottom: 16.h),
              child: _buildProgressBar(
                e.key, 
                e.value > 0 ? '${e.value} Days' : 'No Quota', 
                0.0, // No usage data yet
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

  Widget _buildTopTakersSection() {
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
              _buildTopTakerItem(
                avatar: 'AF',
                avatarColor: const Color(0xFFF43F5E),
                name: 'Amali Fernando',
                role: 'QA Engineer',
                days: '12',
              ),
              Divider(height: 1, color: AppColors.borderLight),
              _buildTopTakerItem(
                avatar: 'KJ',
                avatarColor: const Color(0xFFF59E0B),
                name: 'Kasun Jayawardena',
                role: 'UI Designer',
                days: '09',
              ),
              Divider(height: 1, color: AppColors.borderLight),
              _buildTopTakerItem(
                avatar: 'NP',
                avatarColor: const Color(0xFF0EA5E9),
                name: 'Nuwan Perera',
                role: 'Backend Developer',
                days: '07',
              ),
            ],
          ),
        ),
      ],
    );
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
