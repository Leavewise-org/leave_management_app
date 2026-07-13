import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management_app/shared/placeholder/placeholder_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


// Auth & Dashboard
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/auth/presentation/pages/school_selection_page.dart';
import '../../features/auth/presentation/pages/join_school_page.dart';
import '../../features/auth/presentation/pages/register_school_page.dart';
import '../../features/leave/presentation/pages/dashboard_page.dart';
import '../../features/leave/presentation/pages/apply_leave_page.dart';
import '../../features/leave/presentation/pages/leave_history_page.dart';
import '../../features/leave/presentation/pages/leave_calendar_page.dart';
import '../../features/leave/presentation/pages/profile_page.dart';
import '../../features/leave/presentation/pages/leave_policy_page.dart';
import '../../features/manager/presentation/pages/approvals_page.dart';
import '../../features/manager/presentation/pages/team_view_page.dart';
import '../../features/manager/presentation/pages/reports_page.dart';
import '../../features/school/presentation/pages/admin_dashboard_page.dart';
import '../../features/school/presentation/pages/manage_employees_page.dart';
import '../../features/school/presentation/pages/school_settings_page.dart';
import '../../features/super_admin/presentation/pages/super_admin_dashboard_page.dart';
import '../../features/super_admin/presentation/pages/manage_schools_page.dart';
import '../../features/super_admin/presentation/pages/system_settings_page.dart';

import 'main_shell_page.dart';
import 'admin_shell_page.dart';

part 'app_router.g.dart';

// ── Route paths ────────────────────────────────────────────────────
abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String dashboard = '/home';
  static const String applyLeave = '/home/apply';
  static const String leaveHistory = '/home/history';
  static const String leaveCalendar = '/home/calendar';
  static const String profile = '/home/profile';
  static const String leavePolicy = '/home/policy';
  // Manager
  static const String approvals = '/manager/approvals';
  static const String teamOverview = '/manager/team';
  static const String reports = '/manager/reports';
  // School
  static const String schoolOnboarding = '/school/onboarding';
  static const String joinSchool = '/school/join';
  static const String registerSchool = '/school/register';
  static const String schoolSettings = '/school/settings';
  static const String adminDashboard = '/school/dashboard';
  static const String manageEmployees = '/school/employees';
  // Super Admin
  static const String superAdminDashboard = '/system/dashboard';
  static const String manageSchools = '/system/schools';
  static const String systemSettings = '/system/settings';
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

// ── Router provider ────────────────────────────────────────────────
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authStream = ref.watch(authStateProvider.stream);
  final notifier = GoRouterRefreshStream(authStream);

  ref.onDispose(() {
    notifier.dispose();
  });

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: notifier,

    redirect: (context, state) {
      final userState = ref.read(authStateProvider);
      
      // If the stream is still loading its very first value, wait in splash
      if (userState.isLoading && !userState.hasValue) {
        return AppRoutes.splash;
      }
      
      final user = userState.hasError ? null : userState.valueOrNull;
      final isLoggedIn = user != null;
      final location = state.matchedLocation;

      final isSplash = location == AppRoutes.splash;
      final isLogin = location == AppRoutes.login;
      final isRegister = location == AppRoutes.register;
      final isForgot = location == AppRoutes.forgotPassword;
      final isReset = location == AppRoutes.resetPassword;
      final isOnboarding = location == AppRoutes.schoolOnboarding ||
                           location == AppRoutes.joinSchool ||
                           location == AppRoutes.registerSchool;

      // 1. Not logged in -> send to login (unless already there or on forgot/reset)
      if (!isLoggedIn) {
        if (isLogin || isRegister || isForgot || isReset) return null;
        return AppRoutes.login;
      }

      // 2. Logged in -> check onboarding / pending state
      final schoolId = user.schoolId;
      final role = user.role;

      // Needs to pick a school
      if (schoolId.isEmpty || schoolId == 'unknown') {
        if (!isOnboarding) return AppRoutes.schoolOnboarding;
        return null; // Stay on onboarding
      }

      // Waiting for approval is now handled natively in the dashboard, so no redirect here.

      // Fully onboarded -> send away from splash/login/onboarding
      if (isSplash || isLogin || isRegister || isForgot || isReset || isOnboarding) {
        // If owner/admin/manager -> Admin Dashboard
        if (user.isSchoolAdmin || user.isSuperAdmin || user.isManager) {
           return AppRoutes.adminDashboard;
        }
        return AppRoutes.dashboard;
      }

      return null;
    },

    routes: [
      // Splash — visual only
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),

      // Login
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),

      // Register
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterPage(),
      ),

      // Forgot Password
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordPage(),
      ),

      // Reset Password
      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'resetPassword',
        builder: (context, state) {
          final oobCode = state.uri.queryParameters['oobCode'] ?? '';
          return ResetPasswordPage(oobCode: oobCode);
        },
      ),

      // Employee shell — Dashboard + nested tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                name: 'dashboard',
                builder: (context, state) => const DashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.leaveHistory,
                name: 'leaveHistory',
                builder: (context, state) => const LeaveHistoryPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.leaveCalendar,
                name: 'leaveCalendar',
                builder: (context, state) => const LeaveCalendarPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                name: 'profile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // Pages overlaying the bottom nav (Full screen)
      GoRoute(
        path: AppRoutes.applyLeave,
        name: 'applyLeave',
        builder: (context, state) => const ApplyLeavePage(),
      ),
      GoRoute(
        path: AppRoutes.leavePolicy,
        name: 'leavePolicy',
        builder: (context, state) => const LeavePolicyPage(),
      ),

      // Manager routes
      GoRoute(
        path: AppRoutes.approvals,
        name: 'managerApprovals',
        builder: (context, state) => const ApprovalsPage(),
      ),
      GoRoute(
        path: AppRoutes.teamOverview,
        name: 'managerTeam',
        builder: (context, state) => const TeamViewPage(),
      ),
      GoRoute(
        path: AppRoutes.reports,
        name: 'managerReports',
        builder: (context, state) => const ReportsPage(),
      ),

      // School admin shell — Dashboard + nested tabs
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AdminShellPage(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.adminDashboard,
                name: 'adminDashboard',
                builder: (context, state) => const AdminDashboardPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.manageEmployees,
                name: 'manageEmployees',
                builder: (context, state) => const ManageEmployeesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.schoolSettings,
                name: 'schoolSettings',
                builder: (context, state) => const SchoolSettingsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/school/profile',
                name: 'adminProfile',
                builder: (context, state) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),

      // Super admin routes
      GoRoute(
        path: AppRoutes.superAdminDashboard,
        name: 'superAdminDashboard',
        builder: (context, state) => const SuperAdminDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.manageSchools,
        name: 'manageSchools',
        builder: (context, state) => const ManageSchoolsPage(),
      ),
      GoRoute(
        path: AppRoutes.systemSettings,
        name: 'systemSettings',
        builder: (context, state) => const SystemSettingsPage(),
      ),

      // School onboarding
      GoRoute(
        path: AppRoutes.schoolOnboarding,
        name: 'schoolOnboarding',
        builder: (context, state) => const SchoolSelectionPage(),
      ),
      GoRoute(
        path: AppRoutes.joinSchool,
        name: 'joinSchool',
        builder: (context, state) => const JoinSchoolPage(),
      ),
      GoRoute(
        path: AppRoutes.registerSchool,
        name: 'registerSchool',
        builder: (context, state) => const RegisterSchoolPage(),
      ),
    ],

    // Global error page
    errorBuilder: (context, state) =>
        PlaceholderPage(label: 'Error: ${state.error}'),
  );
}
