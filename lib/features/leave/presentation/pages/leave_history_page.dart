import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:leave_management_app/shared/widgets/status_pill.dart';

class LeaveHistoryPage extends StatelessWidget {
  const LeaveHistoryPage({super.key});

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
          'My History',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
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
                children: [
                  _buildStatsRow(),
                  SizedBox(height: 24.h),
                  _buildHistoryList(),
                  SizedBox(height: 80.h), // padding
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildStatBox(
            val: '08',
            label: 'Used',
            valColor: AppColors.textPrimary,
            labelColor: AppColors.textSecondary,
            bgColor: Colors.white,
            borderColor: AppColors.borderLight,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatBox(
            val: '14',
            label: 'Left',
            valColor: AppColors.approvedText,
            labelColor: AppColors.approvedText,
            bgColor: AppColors.approvedBackground,
            borderColor: AppColors.approvedBackground,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatBox(
            val: '01',
            label: 'Pending',
            valColor: AppColors.pendingText,
            labelColor: AppColors.pendingText,
            bgColor: AppColors.pendingBackground,
            borderColor: AppColors.pendingBackground,
          ),
        ),
      ],
    );
  }

  Widget _buildStatBox({
    required String val,
    required String label,
    required Color valColor,
    required Color labelColor,
    required Color bgColor,
    required Color borderColor,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Text(
            val,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: valColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
              color: labelColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
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
          _buildListItem(
            icon: Icons.work_outline,
            iconColor: AppColors.textSecondary,
            iconBg: AppColors.quickGrayBackground,
            title: 'Casual Leave',
            subtitle: 'May 20 (1 Day)',
            status: 'pending',
          ),
          Divider(height: 1, color: AppColors.borderLight),
          _buildListItem(
            icon: Icons.wb_sunny_outlined,
            iconColor: AppColors.primary,
            iconBg: AppColors.primarySubtle,
            title: 'Annual Leave',
            subtitle: 'Apr 28 - Apr 30 (3 Days)',
            status: 'approved',
          ),
          Divider(height: 1, color: AppColors.borderLight),
          _buildListItem(
            icon: Icons.wb_sunny_outlined,
            iconColor: AppColors.primary,
            iconBg: AppColors.primarySubtle,
            title: 'Annual Leave',
            subtitle: 'May 01 - May 07 (5 Days)',
            status: 'rejected',
          ),
          Divider(height: 1, color: AppColors.borderLight),
          _buildListItem(
            icon: Icons.monitor_heart_outlined,
            iconColor: AppColors.sickLabel,
            iconBg: AppColors.sickBackground,
            title: 'Sick Leave',
            subtitle: 'Mar 12 - Mar 13 (2 Days)',
            status: 'approved',
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String title,
    required String subtitle,
    required String status,
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
          StatusPill(status: status),
        ],
      ),
    );
  }
}
