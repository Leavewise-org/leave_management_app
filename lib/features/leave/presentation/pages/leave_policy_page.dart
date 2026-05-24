import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';

class LeavePolicyPage extends StatelessWidget {
  const LeavePolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        children: [
          _buildPolicyCard(
            title: 'Annual Leave',
            icon: Icons.wb_sunny_outlined,
            iconColor: AppColors.primary,
            bgColor: AppColors.primarySubtle,
            description: 'Employees are entitled to 14 days of paid annual leave per calendar year. Annual leave must be requested at least 3 days in advance. Up to 5 days can be carried forward to the next year.',
          ),
          SizedBox(height: 16.h),
          _buildPolicyCard(
            title: 'Sick Leave',
            icon: Icons.monitor_heart_outlined,
            iconColor: AppColors.sickLabel,
            bgColor: AppColors.sickBackground,
            description: 'Employees are entitled to 7 days of paid sick leave. A valid medical certificate is required for sick leaves exceeding 2 consecutive days.',
          ),
          SizedBox(height: 16.h),
          _buildPolicyCard(
            title: 'Casual Leave',
            icon: Icons.work_outline,
            iconColor: AppColors.textSecondary,
            bgColor: AppColors.quickGrayBackground,
            description: 'Employees are provided 3 days of casual leave for personal or emergency matters. Casual leave cannot be combined with annual leave.',
          ),
          SizedBox(height: 16.h),
          _buildPolicyCard(
            title: 'Maternity/Paternity Leave',
            icon: Icons.child_care,
            iconColor: AppColors.pendingText,
            bgColor: AppColors.pendingBackground,
            description: 'Maternity leave: 84 days of paid leave.\nPaternity leave: 7 days of paid leave to be taken within 30 days of childbirth.',
          ),
          SizedBox(height: 32.h),
        ],
      ),
    );
  }

  Widget _buildPolicyCard({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String description,
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
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: iconColor, size: 24.sp),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
