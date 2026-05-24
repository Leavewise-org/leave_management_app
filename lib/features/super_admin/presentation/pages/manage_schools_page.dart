import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';

class ManageSchoolsPage extends ConsumerWidget {
  const ManageSchoolsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary, size: 28),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Manage Schools',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline, color: AppColors.primary),
            onPressed: () {
              // Navigating to school onboarding
              // Assuming AppRoutes.schoolOnboarding exists in app_router.dart
              context.push('/school/onboarding');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(Icons.search, color: AppColors.textSecondary),
                    hintText: 'Search schools...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                itemCount: 4,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _SchoolListItem(index: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SchoolListItem extends StatelessWidget {
  final int index;
  const _SchoolListItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final bool isSuspended = index == 3;
    final String schoolName = index == 0 ? 'Ananda College' : 'School ${index + 1}';
    final String status = isSuspended ? 'Suspended' : 'Active';
    final Color statusColor = isSuspended ? AppColors.rejectedText : AppColors.approvedText;
    final Color statusBg = isSuspended ? AppColors.rejectedBackground : AppColors.approvedBackground;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.scaffoldBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.domain, color: AppColors.primary, size: 28),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schoolName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(120 - index * 15)} active users',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: statusColor,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: AppColors.textSecondary, size: 20),
                padding: EdgeInsets.zero,
                onSelected: (value) {
                  // Handle action
                },
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  const PopupMenuItem<String>(
                    value: 'edit',
                    child: Text('Edit Info'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'admins',
                    child: Text('Manage Admins'),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem<String>(
                    value: 'suspend',
                    child: Text(
                      isSuspended ? 'Reactivate School' : 'Suspend School',
                      style: TextStyle(
                        color: isSuspended ? AppColors.approvedText : AppColors.rejectedText,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
