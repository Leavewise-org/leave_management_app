import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:leave_management_app/core/router/app_router.dart';
import 'package:leave_management_app/shared/widgets/app_refresh_indicator.dart';
import 'package:leave_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:leave_management_app/features/school/presentation/providers/school_providers.dart';
import 'package:leave_management_app/features/leave/presentation/providers/leave_providers.dart';

class AdminDashboardPage extends ConsumerWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final isManager = user?.isManager ?? false;
    final canManageSchool =
        (user?.isSchoolAdmin ?? false) || (user?.isSuperAdmin ?? false);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded,
              color: AppColors.textPrimary, size: 28),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Admin Console',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: AppRefreshIndicator(
          onRefresh: () async {
            // TODO: Invalidate admin providers here when they are implemented
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome header
                const Text(
                  'School Dashboard',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Overview of all activities in your school',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 16),
                if (user?.schoolId != null && user!.schoolId.isNotEmpty)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                      onTap: () {
                        Clipboard.setData(ClipboardData(text: user.schoolId));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('School ID copied to clipboard!')),
                        );
                      },
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.primarySubtle,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.primary.withOpacity(0.2)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.copy,
                                size: 16, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'School ID',
                                  style: TextStyle(
                                      fontSize: 10,
                                      color: AppColors.primaryText),
                                ),
                                Text(
                                  user.schoolId,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.primary,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                // Quick Metrics
                Consumer(builder: (context, ref, child) {
                  if (user == null || user.schoolId.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final usersAsync =
                      ref.watch(schoolUsersProvider(user.schoolId));
                  final activeEmployeesCount = usersAsync.maybeWhen(
                    data: (users) =>
                        users.where((u) => !u.isPending).length.toString(),
                    error: (e, _) => e.toString(),
                    orElse: () => '...',
                  );

                  final pendingLeavesAsync =
                      ref.watch(pendingLeavesProvider(user.schoolId));
                  final pendingRequestsCount = pendingLeavesAsync.maybeWhen(
                    data: (leaves) => leaves.length.toString(),
                    error: (e, _) => e.toString(),
                    orElse: () => '...',
                  );

                  final allLeavesAsync =
                      ref.watch(allLeavesProvider(user.schoolId));
                  final onLeaveTodayCount = allLeavesAsync.maybeWhen(
                    data: (leaves) {
                      final today = DateTime.now();
                      final todayStart =
                          DateTime(today.year, today.month, today.day);
                      final todayEnd = todayStart
                          .add(const Duration(days: 1))
                          .subtract(const Duration(milliseconds: 1));
                      return leaves
                          .where((l) {
                            if (l.status != 'approved') return false;
                            final leaveStart = DateTime(l.startDate.year,
                                l.startDate.month, l.startDate.day);
                            final leaveEnd = DateTime(l.endDate.year,
                                l.endDate.month, l.endDate.day, 23, 59, 59);
                            return !leaveEnd.isBefore(todayStart) &&
                                !leaveStart.isAfter(todayEnd);
                          })
                          .length
                          .toString();
                    },
                    error: (e, _) => e.toString(),
                    orElse: () => '...',
                  );

                  return Column(
                    children: [
                      _MetricCard(
                        title: 'Active Employees',
                        value: activeEmployeesCount,
                        icon: Icons.people_outline,
                        color: AppColors.primary,
                        backgroundColor: AppColors.primaryLight,
                      ),
                      const SizedBox(height: 12),
                      _MetricCard(
                        title: 'Pending Requests',
                        value: pendingRequestsCount,
                        icon: Icons.pending_actions,
                        color: AppColors.pending,
                        backgroundColor: AppColors.pendingBackground,
                      ),
                      const SizedBox(height: 12),
                      _MetricCard(
                        title: 'On Leave Today',
                        value: onLeaveTodayCount,
                        icon: Icons.event_busy,
                        color: AppColors.rejectedText,
                        backgroundColor: AppColors.rejectedBackground,
                      ),
                    ],
                  );
                }),
                const SizedBox(height: 32),

                // Action Cards
                const Text(
                  'Manage',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (canManageSchool) ...[
                  _ActionCard(
                    title: 'Employee Directory',
                    subtitle: 'Manage roles, view balances, and remove users.',
                    icon: Icons.manage_accounts_outlined,
                    iconColor: AppColors.primary,
                    onTap: () => context.push(AppRoutes.manageEmployees),
                  ),
                  const SizedBox(height: 12),
                  _ActionCard(
                    title: 'School Settings',
                    subtitle: 'Update policies, name, and default quotas.',
                    icon: Icons.settings_outlined,
                    iconColor: AppColors.textSecondary,
                    onTap: () => context.push(AppRoutes.schoolSettings),
                  ),
                ],

                if (isManager) ...[
                  _ActionCard(
                    title: 'Manager Approvals',
                    subtitle:
                        'Review and approve leave requests from your team.',
                    icon: Icons.fact_check_outlined,
                    iconColor: AppColors.pending,
                    onTap: () => context.push(AppRoutes.approvals),
                  ),
                  const SizedBox(height: 12),
                  _ActionCard(
                    title: 'Team Directory',
                    subtitle:
                        'View your team members and their leave balances.',
                    icon: Icons.people_outline,
                    iconColor: AppColors.primary,
                    onTap: () => context.push(AppRoutes.teamOverview),
                  ),
                  const SizedBox(height: 12),
                  _ActionCard(
                    title: 'Team Reports',
                    subtitle:
                        'Analytics and leave reports for your department.',
                    icon: Icons.analytics_outlined,
                    iconColor: AppColors.primary,
                    onTap: () => context.push(AppRoutes.reports),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const _MetricCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  const _ActionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded,
                color: AppColors.textTertiary),
          ],
        ),
      ),
    );
  }
}
