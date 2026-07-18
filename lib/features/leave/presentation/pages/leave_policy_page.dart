import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management_app/features/school/presentation/providers/school_providers.dart';
import 'package:leave_management_app/core/utils/leave_theme_util.dart';

class LeavePolicyPage extends ConsumerWidget {
  const LeavePolicyPage({super.key});

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
          'Leave Policies',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: schoolAsync.when(
        data: (school) {
          if (school == null) {
            return const Center(child: Text('School not found.'));
          }

          final policies = Map<String, num>.from(school.leavePolicies);
          
          // Ensure Unpaid leave is always shown as an option in policies
          if (!policies.keys.any((k) => k.toLowerCase() == 'unpaid' || k.toLowerCase() == 'unpaid leave')) {
            policies['Unpaid'] = 0;
          }

          if (policies.isEmpty) {
            return const Center(child: Text('No leave policies found.'));
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Your Leave Allocations',
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        'Review the leave types available to you and their respective annual quotas according to your school\'s configuration.',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final type = policies.keys.elementAt(index);
                      final quota = policies[type]!;
                      
                      final desc = quota > 0 
                          ? 'You are entitled to a total of $quota days of $type Leave per calendar year. Weekends and public holidays are not deducted from this quota.' 
                          : 'You can apply for $type Leave without a set quota. These leaves are generally unpaid or require special management approval.';
                          
                      final theme = LeaveThemeUtil.getTheme(type);

                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: _buildPolicyCard(
                          title: type,
                          icon: theme.icon,
                          iconColor: theme.baseColor,
                          bgColor: theme.backgroundColor,
                          description: desc,
                          quota: quota,
                        ),
                      );
                    },
                    childCount: policies.length,
                  ),
                ),
              ),
              SliverToBoxAdapter(child: SizedBox(height: 40.h)),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _buildPolicyCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String description,
    required num quota,
  }) {
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
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Icon(icon, color: iconColor, size: 24.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$title Leave',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    if (quota > 0)
                      Text(
                        '$quota Days Quota',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: iconColor,
                        ),
                      )
                    else
                      Text(
                        'Unpaid / No Quota',
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
