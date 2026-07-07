import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:leave_management_app/shared/widgets/status_pill.dart';
import 'package:leave_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:leave_management_app/features/leave/presentation/providers/leave_providers.dart';
import 'package:leave_management_app/features/leave/domain/entities/leave_entity.dart';
import 'package:leave_management_app/shared/widgets/app_refresh_indicator.dart';
import 'package:leave_management_app/core/utils/leave_theme_util.dart';

class LeaveHistoryPage extends ConsumerWidget {
  const LeaveHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).value;
    final userId = user?.id;

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
        body: AppRefreshIndicator(
          onRefresh: () async {
            if (userId != null) {
              ref.invalidate(userLeavesProvider(userId));
            }
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
                  child: Column(
                    children: [
                      if (userId != null) ...[
                        _buildStatsRow(ref, userId),
                        SizedBox(height: 24.h),
                        _buildHistoryList(ref, userId),
                      ] else
                        const Center(child: Text('User not found')),
                      SizedBox(height: 80.h), // padding
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(WidgetRef ref, String userId) {
    final leavesAsync = ref.watch(userLeavesProvider(userId));

    return leavesAsync.when(
      data: (leaves) {
        double used = 0;
        double pending = 0;
        final currentYear = DateTime.now().year;
        for (final l in leaves) {
          if (l.startDate.year == currentYear) {
            if (l.status == 'approved') {
              used += l.durationDays;
            } else if (l.status == 'pending') {
              pending += l.durationDays;
            }
          }
        }
        
        final String usedStr = used == used.truncateToDouble() ? used.toInt().toString().padLeft(2, '0') : used.toString();
        final String pendingStr = pending == pending.truncateToDouble() ? pending.toInt().toString().padLeft(2, '0') : pending.toString();

        return Row(
          children: [
            Expanded(
              child: _buildStatBox(
                val: usedStr,
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
                val: pendingStr,
                label: 'Pending',
                valColor: AppColors.pendingText,
                labelColor: AppColors.pendingText,
                bgColor: AppColors.pendingBackground,
                borderColor: AppColors.pendingBackground,
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading stats')),
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

  Widget _buildHistoryList(WidgetRef ref, String userId) {
    final leavesAsync = ref.watch(userLeavesProvider(userId));

    return leavesAsync.when(
      data: (leaves) {
        if (leaves.isEmpty) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(32.w),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Center(
              child: Text(
                'No leave history found',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
              ),
            ),
          );
        }

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
              for (int i = 0; i < leaves.length; i++) ...[
                _buildListItemFromEntity(leaves[i]),
                if (i < leaves.length - 1)
                  Divider(height: 1, color: AppColors.borderLight),
              ],
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Error loading history')),
    );
  }

  Widget _buildListItemFromEntity(LeaveEntity entity) {
    final theme = LeaveThemeUtil.getTheme(entity.leaveType);

    final dateFormat = DateFormat('MMM dd, yyyy');
    final String durationStr = entity.durationDays == entity.durationDays.truncateToDouble()
        ? entity.durationDays.toInt().toString()
        : entity.durationDays.toString();

    final dateStr = entity.durationDays == 1
        ? '${dateFormat.format(entity.startDate)} (1 Day)'
        : '${dateFormat.format(entity.startDate)} - ${dateFormat.format(entity.endDate)} ($durationStr Days)';

    return _buildListItem(
      icon: theme.icon,
      iconColor: theme.baseColor,
      iconBg: theme.backgroundColor,
      title: '${entity.leaveType} Leave',
      subtitle: dateStr,
      status: entity.status,
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
