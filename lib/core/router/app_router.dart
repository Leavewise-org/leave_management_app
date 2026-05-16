import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leave_management_app/shared/placeholder/placeholder_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Auth
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';

part 'app_router.g.dart';

// ── Route paths ────────────────────────────────────────────────────
abstract class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String dashboard = '/home';
  static const String applyLeave = '/home/apply';
  static const String leaveHistory = '/home/history';
  static const String leaveCalendar = '/home/calendar';
  static const String profile = '/home/profile';
  // Manager
  static const String approvals = '/manager/approvals';
  static const String teamOverview = '/manager/team';
  static const String reports = '/manager/reports';
  // School
  static const String schoolOnboarding = '/school/onboarding';
  static const String schoolSettings = '/school/settings';
}

// ── Auth listenable (no Riverpod chain involved) ───────────────────
/// Wraps Supabase's onAuthStateChange as a [Listenable] for GoRouter.
/// This avoids all Riverpod provider chain / rebuild issues.
class _SupabaseAuthNotifier extends ChangeNotifier {
  _SupabaseAuthNotifier() {
    _sub = Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

// ── Router provider ────────────────────────────────────────────────
@Riverpod(keepAlive: true)
GoRouter appRouter(Ref ref) {
  final authNotifier = _SupabaseAuthNotifier();

  ref.onDispose(() {
    authNotifier.dispose();
  });

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: authNotifier,

    redirect: (context, state) {
      // Check the live session directly — no Riverpod, no streams, no asyncMap
      final session = Supabase.instance.client.auth.currentSession;
      final isLoggedIn = session != null;
      final location = state.matchedLocation;

      final isSplash = location == AppRoutes.splash;
      final isLogin = location == AppRoutes.login;

      // 1. Splash → decide where to go
      if (isSplash) {
        return isLoggedIn ? AppRoutes.dashboard : AppRoutes.login;
      }

      // 2. Not logged in + trying to access a protected page → login
      if (!isLoggedIn && !isLogin) {
        return AppRoutes.login;
      }

      // 3. Logged in + on the login page → dashboard
      if (isLoggedIn && isLogin) {
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

      // Employee shell — Dashboard + nested tabs
      GoRoute(
        path: AppRoutes.dashboard,
        name: 'dashboard',
        builder: (context, state) =>
            const PlaceholderPage(label: 'Dashboard'),
        routes: [
          GoRoute(
            path: 'apply',
            name: 'applyLeave',
            builder: (context, state) =>
                const PlaceholderPage(label: 'Apply Leave'),
          ),
          GoRoute(
            path: 'history',
            name: 'leaveHistory',
            builder: (context, state) =>
                const PlaceholderPage(label: 'Leave History'),
          ),
          GoRoute(
            path: 'calendar',
            name: 'leaveCalendar',
            builder: (context, state) =>
                const PlaceholderPage(label: 'Calendar'),
          ),
          GoRoute(
            path: 'profile',
            name: 'profile',
            builder: (context, state) =>
                const PlaceholderPage(label: 'Profile'),
          ),
        ],
      ),

      // Manager routes
      GoRoute(
        path: AppRoutes.approvals,
        name: 'approvals',
        builder: (context, state) =>
            const PlaceholderPage(label: 'Pending Approvals'),
      ),
      GoRoute(
        path: AppRoutes.teamOverview,
        name: 'teamOverview',
        builder: (context, state) =>
            const PlaceholderPage(label: 'Team Overview'),
      ),
      GoRoute(
        path: AppRoutes.reports,
        name: 'reports',
        builder: (context, state) =>
            const PlaceholderPage(label: 'Reports'),
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
