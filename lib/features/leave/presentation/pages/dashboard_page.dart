import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management_app/core/router/app_router.dart';
import 'package:leave_management_app/shared/widgets/balance_card.dart';
import 'package:leave_management_app/shared/widgets/quick_action_btn.dart';
import 'package:leave_management_app/shared/widgets/status_pill.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:leave_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:intl/intl.dart';
import 'package:leave_management_app/features/leave/domain/entities/leave_entity.dart';
import 'package:leave_management_app/features/leave/presentation/providers/leave_providers.dart';
import 'package:leave_management_app/shared/widgets/app_refresh_indicator.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    
    final userName = user?.fullName ?? 'Employee Name';
    final userInitials = user?.initials ?? 'EMP';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: AppRefreshIndicator(
        onRefresh: () async {
          if (user?.id != null) {
            ref.invalidate(userLeavesProvider(user!.id));
          }
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            _buildAppBar(userName, userInitials),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBalances(ref, user?.id),
                    SizedBox(height: 32.h),
                    _buildQuickActions(context),
                    SizedBox(height: 32.h),
                    _buildRecentRequests(ref, user?.id),
                    SizedBox(height: 80.h), // padding for bottom nav
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(String name, String initials) {
    return SliverAppBar(
      expandedHeight: 100.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Good morning,',
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    CircleAvatar(
                      radius: 22.r,
                      backgroundColor: AppColors.primarySubtle,
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: AppColors.notifBadge,
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.primary, width: 2),
                        ),
                        child: Text(
                          '2',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalances(WidgetRef ref, String? userId) {
    int annualTaken = 0;
    int sickTaken = 0;
    int casualTaken = 0;
    int unpaidTaken = 0;

    if (userId != null) {
      final leavesAsync = ref.watch(userLeavesProvider(userId));
      leavesAsync.whenData((leaves) {
        for (final leave in leaves) {
          if (leave.status == 'approved' || leave.status == 'pending') {
            switch (leave.leaveType) {
              case 'Annual':
                annualTaken += leave.durationDays;
                break;
              case 'Sick':
                sickTaken += leave.durationDays;
                break;
              case 'Casual':
                casualTaken += leave.durationDays;
                break;
              default:
                unpaidTaken += leave.durationDays;
            }
          }
        }
      });
    }

    final int annualTotal = 20;
    final int sickTotal = 10;
    final int casualTotal = 3;

    final String annualLeft = (annualTotal - annualTaken).toString().padLeft(2, '0');
    final String sickLeft = (sickTotal - sickTaken).toString().padLeft(2, '0');
    final String casualLeft = (casualTotal - casualTaken).toString().padLeft(2, '0');
    final String unpaidStr = unpaidTaken.toString().padLeft(2, '0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'My Balances',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'Details',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: BalanceCard(
                title: 'Annual',
                value: annualLeft,
                subtitle: 'of $annualTotal days left',
                icon: Icons.wb_sunny_outlined,
                baseColor: AppColors.annualLabel,
                backgroundColor: AppColors.annualBackground,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: BalanceCard(
                title: 'Sick',
                value: sickLeft,
                subtitle: 'of $sickTotal days left',
                icon: Icons.monitor_heart_outlined,
                baseColor: AppColors.sickLabel,
                backgroundColor: AppColors.sickBackground,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: BalanceCard(
                title: 'Casual',
                value: casualLeft,
                subtitle: 'of $casualTotal days left',
                icon: Icons.work_outline,
                baseColor: AppColors.pending,
                backgroundColor: AppColors.pendingBackground,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: BalanceCard(
                title: 'Unpaid',
                value: unpaidStr,
                subtitle: 'days taken',
                icon: Icons.money_off,
                baseColor: AppColors.unpaidLabel,
                backgroundColor: Colors.transparent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            QuickActionBtn(
              icon: Icons.add_circle_outline,
              label: 'Apply\nLeave',
              color: AppColors.primary,
              backgroundColor: AppColors.quickBlueBackground,
              onTap: () => context.go(AppRoutes.applyLeave),
            ),
            QuickActionBtn(
              icon: Icons.calendar_today_outlined,
              label: 'Calendar\nView',
              color: AppColors.textSecondary,
              backgroundColor: Colors.transparent,
              onTap: () => context.go(AppRoutes.leaveCalendar),
            ),
            QuickActionBtn(
              icon: Icons.history,
              label: 'My\nHistory',
              color: AppColors.textSecondary,
              backgroundColor: Colors.transparent,
              onTap: () => context.go(AppRoutes.leaveHistory),
            ),
            QuickActionBtn(
              icon: Icons.policy_outlined,
              label: 'Leave\nPolicies',
              color: AppColors.textSecondary,
              backgroundColor: Colors.transparent,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRecentRequests(WidgetRef ref, String? userId) {
    if (userId == null) return const SizedBox.shrink();

    final leavesAsync = ref.watch(userLeavesProvider(userId));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Requests',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              'View All',
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        leavesAsync.when(
          data: (leaves) {
            if (leaves.isEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: AppColors.borderLight),
                ),
                child: Center(
                  child: Text(
                    'No recent requests',
                    style: TextStyle(color: AppColors.textSecondary, fontSize: 14.sp),
                  ),
                ),
              );
            }

            final recentLeaves = leaves.take(3).toList();
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
                  for (int i = 0; i < recentLeaves.length; i++) ...[
                    _buildListItemFromEntity(recentLeaves[i]),
                    if (i < recentLeaves.length - 1)
                      Divider(height: 1, color: AppColors.borderLight),
                  ],
                ],
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, st) {
            print('Error loading requests: $e');
            return Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: Colors.red.withOpacity(0.5)),
              ),
              child: Center(
                child: Text(
                  'Error: $e',
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildListItemFromEntity(LeaveEntity entity) {
    IconData icon;
    Color iconColor;
    Color iconBg;

    switch (entity.leaveType) {
      case 'Annual':
        icon = Icons.wb_sunny_outlined;
        iconColor = AppColors.annualLabel;
        iconBg = AppColors.annualBackground;
        break;
      case 'Sick':
        icon = Icons.monitor_heart_outlined;
        iconColor = AppColors.sickLabel;
        iconBg = AppColors.sickBackground;
        break;
      case 'Casual':
        icon = Icons.work_outline;
        iconColor = AppColors.pending;
        iconBg = AppColors.pendingBackground;
        break;
      default:
        icon = Icons.access_time;
        iconColor = AppColors.textSecondary;
        iconBg = AppColors.borderLight;
    }

    final dateFormat = DateFormat('MMM dd');
    final dateStr = entity.durationDays == 1
        ? '${dateFormat.format(entity.startDate)} (1 Day)'
        : '${dateFormat.format(entity.startDate)} - ${dateFormat.format(entity.endDate)} (${entity.durationDays} Days)';

    return _buildListItem(
      icon: icon,
      iconColor: iconColor,
      iconBg: iconBg,
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
