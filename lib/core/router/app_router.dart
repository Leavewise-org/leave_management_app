import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management_app/shared/placeholder/placeholder_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Auth & Dashboard
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
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

import 'main_shell_page.dart';

part 'app_router.g.dart';

// ── Route paths ────────────────────────────────────────────────────
abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
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
  static const String schoolSettings = '/school/settings';
  static const String adminDashboard = '/school/dashboard';
  static const String manageEmployees = '/school/employees';
}

// ── Auth listenable (no Riverpod chain involved) ───────────────────
/// Wraps Firebase's authStateChanges as a [Listenable] for GoRouter.
/// This avoids all Riverpod provider chain / rebuild issues.
class _FirebaseAuthNotifier extends ChangeNotifier {
  _FirebaseAuthNotifier() {
    _sub = FirebaseAuth.instance.authStateChanges().listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<User?> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

// ── Router provider ────────────────────────────────────────────────
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authNotifier = _FirebaseAuthNotifier();

  ref.onDispose(() {
    authNotifier.dispose();
  });

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: authNotifier,

    redirect: (context, state) {
      // Check the live session directly — no Riverpod, no streams, no asyncMap
      final currentUser = FirebaseAuth.instance.currentUser;
      final isLoggedIn = currentUser != null;
      final location = state.matchedLocation;

      final isSplash = location == AppRoutes.splash;
      final isLogin = location == AppRoutes.login;
      final isRegister = location == AppRoutes.register;

      // 1. Splash → decide where to go
      if (isSplash) {
        return isLoggedIn ? AppRoutes.dashboard : AppRoutes.login;
      }

      // 2. Not logged in + trying to access a protected page → login
      if (!isLoggedIn && !isLogin && !isRegister) {
        return AppRoutes.login;
      }

      // 3. Logged in + on the login/register page → dashboard
      if (isLoggedIn && (isLogin || isRegister)) {
        return AppRoutes.dashboard;
      }

      // No redirect needed
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

      // School admin routes
      GoRoute(
        path: AppRoutes.adminDashboard,
        name: 'adminDashboard',
        builder: (context, state) => const AdminDashboardPage(),
      ),
      GoRoute(
        path: AppRoutes.manageEmployees,
        name: 'manageEmployees',
        builder: (context, state) => const ManageEmployeesPage(),
      ),
      GoRoute(
        path: AppRoutes.schoolSettings,
        name: 'schoolSettings',
        builder: (context, state) => const SchoolSettingsPage(),
      ),

      // School onboarding
      GoRoute(
        path: AppRoutes.schoolOnboarding,
        name: 'schoolOnboarding',
        builder: (context, state) =>
            const PlaceholderPage(label: 'School Onboarding'),
      ),
    ],

    // Global error page
    errorBuilder: (context, state) =>
        PlaceholderPage(label: 'Error: ${state.error}'),
  );
}
