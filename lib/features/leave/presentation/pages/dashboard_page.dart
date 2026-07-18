import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:leave_management_app/features/school/presentation/providers/school_providers.dart';
import 'package:leave_management_app/core/utils/leave_theme_util.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    
    final userName = user?.fullName ?? 'Employee Name';
    final userInitials = user?.initials ?? 'EMP';
    final isPending = user?.role == 'pending';
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
            _buildAppBar(userName, userInitials, user?.schoolId ?? '', context),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildBalances(ref, user?.id),
                    SizedBox(height: 32.h),
                    if (isPending)
                      _buildPendingWarning()
                    else ...[
                      _buildQuickActions(context),
                      SizedBox(height: 32.h),
                      _buildRecentRequests(ref, user?.id),
                    ],
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

  Widget _buildAppBar(String name, String initials, String schoolId, BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting = 'Good morning,';
    if (hour >= 12 && hour < 17) {
      greeting = 'Good afternoon,';
    } else if (hour >= 17) {
      greeting = 'Good evening,';
    }

    return SliverAppBar(
      expandedHeight: 120.h,
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
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        greeting,
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
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 4.h),
                      if (schoolId.isNotEmpty)
                        InkWell(
                          onTap: () {
                            Clipboard.setData(ClipboardData(text: schoolId));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('School ID copied to clipboard!')),
                            );
                          },
                          borderRadius: BorderRadius.circular(4.r),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'School ID: $schoolId',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              Icon(Icons.copy, color: Colors.white, size: 14.sp),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(width: 16.w),
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
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalances(WidgetRef ref, String? userId) {
    if (userId == null) return const SizedBox.shrink();

    final schoolAsync = ref.watch(currentSchoolProvider);
    final leavesAsync = ref.watch(userLeavesProvider(userId));

    return schoolAsync.when(
      data: (school) {
        if (school == null) return const Center(child: Text('School not found'));
        
        final policies = school.leavePolicies;
        final takenMap = <String, double>{};
        double unpaidTaken = 0;

        leavesAsync.whenData((leaves) {
          final currentYear = DateTime.now().year;
          for (final leave in leaves) {
            // ONLY subtract leaves taken in the current year
            if (leave.startDate.year == currentYear) {
              if (leave.status == 'approved' || leave.status == 'pending') {
                if (policies.containsKey(leave.leaveType) && policies[leave.leaveType]! > 0) {
                  takenMap[leave.leaveType] = (takenMap[leave.leaveType] ?? 0) + leave.durationDays;
                } else {
                  unpaidTaken += leave.durationDays;
                }
              }
            }
          }
        });

        // We want to group BalanceCards in pairs
        final List<Widget> balanceCards = [];
        
        policies.forEach((type, quota) {
          if (quota > 0) {
            final double taken = takenMap[type] ?? 0.0;
            final double left = quota - taken;
            
            // Format to show .5 if needed, else whole number
            final String leftStr = left == left.truncateToDouble() 
                ? left.toInt().toString().padLeft(2, '0') 
                : left.toString();
            
            final theme = LeaveThemeUtil.getTheme(type);

            balanceCards.add(
              BalanceCard(
                title: type,
                value: leftStr,
                subtitle: 'of $quota days left',
                icon: theme.icon,
                baseColor: theme.baseColor,
                backgroundColor: theme.backgroundColor,
              )
            );
          }
        });

        // Always show unpaid or 0 quota taken
        // Format unpaid to show .5 if needed
        final String unpaidStr = unpaidTaken == unpaidTaken.truncateToDouble()
            ? unpaidTaken.toInt().toString().padLeft(2, '0')
            : unpaidTaken.toString();

        balanceCards.add(
          BalanceCard(
            title: 'Unpaid / Extra',
            value: unpaidStr,
            subtitle: 'days taken',
            icon: Icons.money_off,
            baseColor: AppColors.unpaidLabel,
            backgroundColor: Colors.transparent,
          )
        );

        final List<Widget> rows = [];
        for (int i = 0; i < balanceCards.length; i += 2) {
          rows.add(
            Row(
              children: [
                Expanded(child: balanceCards[i]),
                SizedBox(width: 12.w),
                if (i + 1 < balanceCards.length)
                  Expanded(child: balanceCards[i + 1])
                else
                  Expanded(child: const SizedBox()),
              ],
            )
          );
          if (i + 2 < balanceCards.length) {
            rows.add(SizedBox(height: 12.h));
          }
        }

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
            ...rows,
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildPendingWarning() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.pendingBackground,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.pending.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.hourglass_empty, color: AppColors.pending, size: 24.w),
              SizedBox(width: 12.w),
              Text(
                'Waiting for Approval',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.pendingText,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            'Your account is currently pending. You will not be able to apply for leave until your School Admin or Manager approves your account.',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.pendingText.withOpacity(0.8),
              height: 1.5,
            ),
          ),
        ],
      ),
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
              onTap: () => context.push(AppRoutes.applyLeave),
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
              onTap: () => context.push(AppRoutes.leavePolicy),
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
    final theme = LeaveThemeUtil.getTheme(entity.leaveType);

    final dateFormat = DateFormat('MMM dd');
    final String durationStr = entity.durationDays == entity.durationDays.truncateToDouble()
        ? entity.durationDays.toInt().toString()
        : entity.durationDays.toString();

    final isSameDay = entity.startDate.year == entity.endDate.year && 
                      entity.startDate.month == entity.endDate.month && 
                      entity.startDate.day == entity.endDate.day;

    final dateStr = isSameDay
        ? '${dateFormat.format(entity.startDate)} (1 Day)'
        : '${dateFormat.format(entity.startDate)} \u2013 ${dateFormat.format(entity.endDate)} ($durationStr Days)';

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
