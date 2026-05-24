import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:leave_management_app/shared/widgets/status_pill.dart';

class TeamViewPage extends StatelessWidget {
  const TeamViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Team Directory',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.h),
          child: Padding(
            padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 16.h),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search team members...',
                hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
                prefixIcon: Icon(Icons.search, color: AppColors.textSecondary, size: 20.sp),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(vertical: 0.h),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
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
                  _buildTeamList(),
                  SizedBox(height: 80.h),
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
            label: 'Total',
            valColor: AppColors.textPrimary,
            labelColor: AppColors.textSecondary,
            bgColor: Colors.white,
            borderColor: AppColors.borderLight,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatBox(
            val: '05',
            label: 'Active',
            valColor: AppColors.approvedText,
            labelColor: AppColors.approvedText,
            bgColor: AppColors.approvedBackground,
            borderColor: AppColors.approvedBackground,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatBox(
            val: '03',
            label: 'On Leave',
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

  Widget _buildTeamList() {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Text(
              'Engineering Dept',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
          ),
          _buildListItem(
            avatar: 'NP',
            avatarColor: const Color(0xFF0EA5E9),
            name: 'Nuwan Perera',
            role: 'Backend Developer',
            status: 'approved', // Maps to Green (Working)
          ),
          Divider(height: 1, color: AppColors.borderLight),
          _buildListItem(
            avatar: 'SR',
            avatarColor: const Color(0xFF10B981),
            name: 'Sajith Sampath',
            role: 'Software Engineer',
            status: 'approved',
          ),
          Divider(height: 1, color: AppColors.borderLight),
          _buildListItem(
            avatar: 'DP',
            avatarColor: const Color(0xFF8B5CF6),
            name: 'Dilani Prasad',
            role: 'DevOps Engineer',
            status: 'pending', // Maps to Amber (On Leave)
          ),
          
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 8.h),
            child: Text(
              'QA & Design',
              style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
            ),
          ),
          Divider(height: 1, color: AppColors.borderLight),
          _buildListItem(
            avatar: 'AF',
            avatarColor: const Color(0xFFF43F5E),
            name: 'Amali Fernando',
            role: 'QA Engineer',
            status: 'pending',
          ),
          Divider(height: 1, color: AppColors.borderLight),
          _buildListItem(
            avatar: 'KJ',
            avatarColor: const Color(0xFFF59E0B),
            name: 'Kasun Jayawardena',
            role: 'UI Designer',
            status: 'approved',
          ),
        ],
      ),
    );
  }

  Widget _buildListItem({
    required String avatar,
    required Color avatarColor,
    required String name,
    required String role,
    required String status,
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
          StatusPill(status: status), // We can tweak StatusPill later to take custom text if needed
        ],
      ),
    );
  }
}
