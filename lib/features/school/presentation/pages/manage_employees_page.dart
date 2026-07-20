import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:leave_management_app/features/auth/domain/entities/user_entity.dart';
import 'package:leave_management_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:leave_management_app/features/school/presentation/providers/school_providers.dart';

class ManageEmployeesPage extends ConsumerWidget {
  const ManageEmployeesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final currentUser = authState.value;
    
    if (currentUser == null || currentUser.schoolId.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final usersAsync = ref.watch(schoolUsersProvider(currentUser.schoolId));

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/school/dashboard');
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary, size: 28),
          onPressed: () => context.go('/school/dashboard'),
        ),
        title: const Text(
          'Manage Employees',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
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
                    hintText: 'Search employees...',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 15),
                  ),
                ),
              ),
            ),
            Expanded(
              child: usersAsync.when(
                data: (users) {
                  final pendingUsers = users.where((u) => u.isPending).toList();
                  final activeUsers = users.where((u) => !u.isPending).toList();

                  if (users.isEmpty) {
                    return const Center(child: Text('No employees found.'));
                  }

                  return ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                    children: [
                      if (pendingUsers.isNotEmpty) ...[
                        const Text(
                          'Pending Approvals',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.pendingText),
                        ),
                        const SizedBox(height: 12),
                        ...pendingUsers.map((u) => _EmployeeListItem(user: u, isCurrentUser: u.id == currentUser.id)),
                        const SizedBox(height: 24),
                      ],
                      if (activeUsers.isNotEmpty) ...[
                        const Text(
                          'Active Employees',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 12),
                        ...activeUsers.map((u) => _EmployeeListItem(user: u, isCurrentUser: u.id == currentUser.id)),
                      ],
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _EmployeeListItem extends ConsumerWidget {
  final UserEntity user;
  final bool isCurrentUser;
  
  const _EmployeeListItem({required this.user, required this.isCurrentUser});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: user.isPending ? AppColors.pendingBackground : AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: user.isPending ? AppColors.pending : AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: user.isManager || user.isSchoolAdmin ? AppColors.primaryLight : AppColors.quickBlueBackground,
            foregroundColor: AppColors.primary,
            radius: 24,
            child: Text(
              user.initials,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        user.fullName + (isCurrentUser ? ' (You)' : ''),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  user.isPending ? 'Pending Approval' : _formatRole(user.role),
                  style: TextStyle(
                    fontSize: 13,
                    color: user.isPending ? AppColors.pendingText : AppColors.textSecondary,
                    fontWeight: user.isPending ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          if (user.isPending)
            TextButton(
              onPressed: () async {
                final repo = ref.read(schoolRepositoryProvider);
                await repo.updateUserRole(user.id, 'employee');
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${user.fullName} approved!')),
                  );
                }
              },
              style: TextButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: const Text('Approve', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          else
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
              onSelected: (value) async {
                final repo = ref.read(schoolRepositoryProvider);
                if (value == 'make_manager') {
                  await repo.updateUserRole(user.id, 'manager');
                } else if (value == 'make_employee') {
                  await repo.updateUserRole(user.id, 'employee');
                } else if (value == 'remove') {
                  // In a real app we'd probably soft delete or clear school_id
                  await repo.updateUserRole(user.id, 'removed');
                }
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                if (!user.isManager && !user.isSchoolAdmin)
                  const PopupMenuItem<String>(
                    value: 'make_manager',
                    child: Text('Make Manager'),
                  ),
                if (user.isManager && !user.isSchoolAdmin)
                  const PopupMenuItem<String>(
                    value: 'make_employee',
                    child: Text('Demote to Employee'),
                  ),
                const PopupMenuDivider(),
                const PopupMenuItem<String>(
                  value: 'remove',
                  child: Text('Deactivate User', style: TextStyle(color: AppColors.rejectedText)),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatRole(String role) {
    if (role == 'school_admin') return 'School Admin';
    if (role == 'super_admin') return 'Super Admin';
    if (role == 'manager') return 'Manager';
    return 'Employee';
  }
}
