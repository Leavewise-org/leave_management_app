import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';

class ManageEmployeesPage extends ConsumerWidget {
  const ManageEmployeesPage({super.key});

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
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
                itemCount: 5,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return _EmployeeListItem(index: index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmployeeListItem extends StatelessWidget {
  final int index;
  const _EmployeeListItem({required this.index});

  @override
  Widget build(BuildContext context) {
    final bool isManager = index == 0;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isManager ? AppColors.primaryLight : AppColors.quickBlueBackground,
            foregroundColor: isManager ? AppColors.primary : AppColors.primary,
            radius: 24,
            child: Text(
              isManager ? 'JD' : 'E$index',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isManager ? 'John Doe' : 'Employee $index',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isManager ? 'Manager' : 'Employee',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            onSelected: (value) {
              // Handle action
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'role',
                child: Text('Change Role'),
              ),
              const PopupMenuItem<String>(
                value: 'balances',
                child: Text('View Balances'),
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
}
