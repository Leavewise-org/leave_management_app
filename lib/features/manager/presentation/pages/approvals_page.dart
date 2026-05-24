import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:leave_management_app/shared/widgets/status_pill.dart';

class ApprovalsPage extends StatelessWidget {
  const ApprovalsPage({super.key});

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
          'Approvals',
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
                  _buildPendingBadge(),
                  SizedBox(height: 24.h),
                  _buildApprovalCard(
                    avatarText: 'NP',
                    avatarColor: const Color(0xFF0EA5E9),
                    name: 'Nuwan Perera',
                    role: 'Backend Developer',
                    duration: '3 Days',
                    leaveType: 'Annual Leave',
                    leaveIcon: Icons.wb_sunny_outlined,
                    leaveColor: AppColors.primary,
                    dateRange: 'May 22 – May 24, 2026',
                    reason: 'Family vacation trip',
                  ),
                  SizedBox(height: 16.h),
                  _buildApprovalCard(
                    avatarText: 'AF',
                    avatarColor: const Color(0xFFF43F5E),
                    name: 'Amali Fernando',
                    role: 'QA Engineer',
                    duration: '2 Days',
                    durationBg: AppColors.approvedBackground,
                    durationColor: AppColors.approvedText,
                    leaveType: 'Sick Leave',
                    leaveIcon: Icons.monitor_heart_outlined,
                    leaveColor: AppColors.sickLabel,
                    dateRange: 'May 19 – May 20, 2026',
                    reason: 'Medical appointment + recovery',
                    attachment: 'medical_cert.pdf',
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

  Widget _buildPendingBadge() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.pendingBackground,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.access_time, color: AppColors.pendingText, size: 14.sp),
          SizedBox(width: 6.w),
          Text(
            '3 Pending Requests',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.pendingText,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApprovalCard({
    required String avatarText,
    required Color avatarColor,
    required String name,
    required String role,
    required String duration,
    Color durationBg = AppColors.pendingBackground,
    Color durationColor = AppColors.pendingText,
    required String leaveType,
    required IconData leaveIcon,
    required Color leaveColor,
    required String dateRange,
    required String reason,
    String? attachment,
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
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: avatarColor,
                radius: 20.r,
                child: Text(
                  avatarText,
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    Text(
                      role,
                      style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: durationBg,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(
                  duration,
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    color: durationColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildDetailRow(leaveIcon, leaveColor, leaveType),
          SizedBox(height: 8.h),
          _buildDetailRow(Icons.calendar_today_outlined, AppColors.textSecondary, dateRange),
          SizedBox(height: 8.h),
          _buildDetailRow(Icons.chat_bubble_outline, AppColors.textSecondary, reason),
          if (attachment != null) ...[
            SizedBox(height: 8.h),
            _buildDetailRow(Icons.attach_file, AppColors.primary, attachment),
          ],
          SizedBox(height: 20.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.close, size: 18.sp),
                  label: const Text('Reject'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.rejected,
                    side: const BorderSide(color: AppColors.rejectedBackground),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.check, size: 18.sp),
                  label: const Text('Approve'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.approvedText,
                    side: const BorderSide(color: AppColors.approvedBackground),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.r)),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, Color iconColor, String text) {
    return Row(
      children: [
        Icon(icon, size: 16.sp, color: iconColor),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 13.sp, color: AppColors.textPrimary),
          ),
        ),
      ],
    );
  }
}
