import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:leave_management_app/core/router/app_router.dart';
import 'package:leave_management_app/features/auth/presentation/providers/auth_provider.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    final userName = user?.fullName ?? 'John Doe';
    final userInitials = user?.initials ?? 'JD';
    final userRole = user?.role == 'employee' ? 'Employee' : (user?.role ?? 'Senior Mobile Developer');

    final currentUri = GoRouterState.of(context).uri.toString();
    final backRoute = currentUri.startsWith('/school') 
        ? AppRoutes.adminDashboard
        : currentUri.startsWith('/system')
            ? AppRoutes.superAdminDashboard
            : AppRoutes.dashboard;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go(backRoute);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        appBar: AppBar(
          backgroundColor: AppColors.scaffoldBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
            onPressed: () => context.go(backRoute),
          ),
          title: Text(
            'My Profile',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            children: [
              _buildProfileHeader(userName, userInitials, userRole, user?.departmentId),
              SizedBox(height: 32.h),
              _buildMenuSection(context, ref, user?.role),
            ],
          ),
        ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(String name, String initials, String role, String? departmentId) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundColor: AppColors.primarySubtle,
              child: Text(
                initials,
                style: TextStyle(
                  fontSize: 32.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(4.w),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.edit, color: Colors.white, size: 16.sp),
              ),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Text(
          name,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          role,
          style: TextStyle(
            fontSize: 14.sp,
            color: AppColors.textSecondary,
          ),
        ),
        if (departmentId != null && departmentId.isNotEmpty) ...[
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.approvedBackground,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              departmentId,
              style: TextStyle(
                color: AppColors.approvedText,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context, WidgetRef ref, String? role) {
    final isSuperAdmin = role == 'super_admin';
    final isAdmin = role == 'school_admin' || isSuperAdmin;
    final isManager = role == 'manager' || isAdmin;

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
          // View Switcher logic
          if (isSuperAdmin && !GoRouterState.of(context).uri.toString().startsWith('/system')) ...[
            _buildMenuItem(
              icon: Icons.admin_panel_settings,
              title: 'Switch to System Console',
              iconColor: AppColors.primary,
              onTap: () {
                context.go(AppRoutes.superAdminDashboard);
              },
            ),
            Divider(height: 1, color: AppColors.borderLight, indent: 56.w),
          ],
          if ((isAdmin || isManager) && !GoRouterState.of(context).uri.toString().startsWith('/school')) ...[
            _buildMenuItem(
              icon: Icons.admin_panel_settings_outlined,
              title: 'Switch to Admin Console',
              iconColor: AppColors.primary,
              onTap: () {
                context.go(AppRoutes.adminDashboard);
              },
            ),
            Divider(height: 1, color: AppColors.borderLight, indent: 56.w),
          ],
          if ((isAdmin || isManager) && (GoRouterState.of(context).uri.toString().startsWith('/school') || GoRouterState.of(context).uri.toString().startsWith('/system'))) ...[
            _buildMenuItem(
              icon: Icons.switch_account_outlined,
              title: 'Switch to Employee View',
              iconColor: AppColors.primary,
              onTap: () {
                context.go(AppRoutes.dashboard);
              },
            ),
            Divider(height: 1, color: AppColors.borderLight, indent: 56.w),
          ],
          _buildMenuItem(
            icon: Icons.person_outline,
            title: 'Personal Information',
            onTap: () {},
          ),
          Divider(height: 1, color: AppColors.borderLight, indent: 56.w),
          _buildMenuItem(
            icon: Icons.description_outlined,
            title: 'Leave Policies',
            onTap: () {
              context.pushNamed('leavePolicy');
            },
          ),
          Divider(height: 1, color: AppColors.borderLight, indent: 56.w),
          _buildMenuItem(
            icon: Icons.settings_outlined,
            title: 'Settings',
            onTap: () {},
          ),
          Divider(height: 1, color: AppColors.borderLight, indent: 56.w),
          _buildMenuItem(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: () {},
          ),
          Divider(height: 1, color: AppColors.borderLight, indent: 56.w),
          _buildMenuItem(
            icon: Icons.logout,
            title: 'Logout',
            textColor: AppColors.rejected,
            iconColor: AppColors.rejected,
            onTap: () {
              ref.read(signInNotifierProvider.notifier).signOut();
            },
            showChevron: false,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? textColor,
    Color? iconColor,
    bool showChevron = true,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      leading: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.primary, size: 20.sp),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: textColor ?? AppColors.textPrimary,
        ),
      ),
      trailing: showChevron
          ? Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20.sp)
          : null,
      onTap: onTap,
    );
  }
}
