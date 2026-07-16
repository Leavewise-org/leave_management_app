import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:leave_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:leave_management_app/features/leave/domain/entities/leave_entity.dart';
import 'package:leave_management_app/features/leave/presentation/providers/leave_providers.dart';
import 'package:leave_management_app/shared/widgets/app_refresh_indicator.dart';
import 'package:leave_management_app/core/utils/leave_theme_util.dart';

class ApprovalsPage extends ConsumerWidget {
  const ApprovalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    if (user == null) return const Scaffold();

    final pendingLeavesAsync = ref.watch(pendingLeavesProvider(user.schoolId));
    final allLeavesAsync = ref.watch(allLeavesProvider(user.schoolId));

    ref.listen(manageLeaveNotifierProvider, (prev, next) {
      if (next.failure != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.failure!.message)),
        );
      }
    });

    return DefaultTabController(
      length: 2,
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
            'Approvals',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            tabs: [
              Tab(text: 'Pending'),
              Tab(text: 'History'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- PENDING TAB ---
            AppRefreshIndicator(
              onRefresh: () async {
                ref.invalidate(pendingLeavesProvider(user.schoolId));
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                      child: pendingLeavesAsync.when(
                        data: (leaves) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildPendingBadge(leaves.length),
                              SizedBox(height: 24.h),
                              if (leaves.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 40.h),
                                    child: Text(
                                      'No pending requests right now.',
                                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp),
                                    ),
                                  ),
                                )
                              else
                                for (final leave in leaves) ...[
                                  _buildApprovalCardFromEntity(ref, leave, isHistory: false),
                                  SizedBox(height: 16.h),
                                ],
                              SizedBox(height: 80.h),
                            ],
                          );
                        },
                        loading: () => const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())),
                        error: (e, st) {
                          print('Error loading approvals: $e');
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Text(
                                'No pending requests right now.',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // --- HISTORY TAB ---
            AppRefreshIndicator(
              onRefresh: () async {
                ref.invalidate(allLeavesProvider(user.schoolId));
              },
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                      child: allLeavesAsync.when(
                        data: (allLeaves) {
                          final historyLeaves = allLeaves.where((l) => l.status != 'pending').toList();
                          
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (historyLeaves.isEmpty)
                                Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 40.h),
                                    child: Text(
                                      'No past approvals found.',
                                      style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp),
                                    ),
                                  ),
                                )
                              else
                                for (final leave in historyLeaves) ...[
                                  _buildApprovalCardFromEntity(ref, leave, isHistory: true),
                                  SizedBox(height: 16.h),
                                ],
                              SizedBox(height: 80.h),
                            ],
                          );
                        },
                        loading: () => const Center(child: Padding(padding: EdgeInsets.all(40), child: CircularProgressIndicator())),
                        error: (e, st) {
                          print('Error loading history: $e');
                          return Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 40.h),
                              child: Text(
                                'Error loading history.',
                                style: TextStyle(color: AppColors.textSecondary, fontSize: 16.sp),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingBadge(int count) {
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
            '$count Pending Requests',
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

  Widget _buildApprovalCardFromEntity(WidgetRef ref, LeaveEntity entity, {required bool isHistory}) {
    final theme = LeaveThemeUtil.getTheme(entity.leaveType);

    final dateFormat = DateFormat('MMM dd, yyyy');
    final String durationStr = entity.durationDays == entity.durationDays.truncateToDouble()
        ? entity.durationDays.toInt().toString()
        : entity.durationDays.toString();

    final dateStr = entity.durationDays == 1
        ? dateFormat.format(entity.startDate)
        : '${dateFormat.format(entity.startDate)} \u2013 ${dateFormat.format(entity.endDate)}';
    
    return _buildApprovalCard(
      ref: ref,
      leaveId: entity.id,
      avatarText: _getInitials(entity.userName),
      avatarColor: AppColors.primary,
      name: entity.userName,
      role: 'Employee',
      duration: '$durationStr Day${entity.durationDays > 1 ? 's' : ''}',
      leaveType: '${entity.leaveType} Leave',
      leaveIcon: theme.icon,
      leaveColor: theme.baseColor,
      dateRange: dateStr,
      reason: entity.reason,
      attachment: entity.attachmentUrl,
      isHistory: isHistory,
      status: entity.status,
    );
  }

  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Widget _buildApprovalCard({
    required WidgetRef ref,
    required String leaveId,
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
    required bool isHistory,
    required String status,
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
              if (isHistory)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: status == 'approved' ? AppColors.approvedBackground : AppColors.rejectedBackground,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: status == 'approved' ? AppColors.approvedText : AppColors.rejectedText,
                    ),
                  ),
                )
              else
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
          if (!isHistory) ...[
            SizedBox(height: 20.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      ref.read(manageLeaveNotifierProvider.notifier).updateStatus(leaveId, 'rejected');
                    },
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
                    onPressed: () {
                      ref.read(manageLeaveNotifierProvider.notifier).updateStatus(leaveId, 'approved');
                    },
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
