import 'package:flutter/material.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';

class LeaveTheme {
  final IconData icon;
  final Color baseColor;
  final Color backgroundColor;

  const LeaveTheme({
    required this.icon,
    required this.baseColor,
    required this.backgroundColor,
  });
}

class LeaveThemeUtil {
  /// Defines a set of fallback color combinations for dynamic leave types
  static const List<LeaveTheme> _dynamicThemes = [
    LeaveTheme(
      icon: Icons.event_note,
      baseColor: AppColors.avatarPurple,
      backgroundColor: Color(0xFFF0EFFF), // Light purple
    ),
    LeaveTheme(
      icon: Icons.card_travel,
      baseColor: AppColors.avatarCoral,
      backgroundColor: Color(0xFFFFF0EB), // Light coral
    ),
    LeaveTheme(
      icon: Icons.family_restroom,
      baseColor: AppColors.avatarTeal,
      backgroundColor: Color(0xFFE1F5EE), // Light teal
    ),
    LeaveTheme(
      icon: Icons.flight_takeoff,
      baseColor: AppColors.avatarBlue,
      backgroundColor: Color(0xFFE6F1FB), // Light blue
    ),
    LeaveTheme(
      icon: Icons.local_hospital,
      baseColor: Color(0xFFC0392B), // Dark Red
      backgroundColor: Color(0xFFFDEDEC), // Light Red
    ),
  ];

  /// Get the theme (icon, baseColor, backgroundColor) for a given leave type
  static LeaveTheme getTheme(String leaveType) {
    final type = leaveType.toLowerCase();

    if (type.contains('annual') || type.contains('vacation')) {
      return const LeaveTheme(
        icon: Icons.wb_sunny_outlined,
        baseColor: AppColors.annualLabel,
        backgroundColor: AppColors.annualBackground,
      );
    } else if (type.contains('sick') || type.contains('medical')) {
      return const LeaveTheme(
        icon: Icons.monitor_heart_outlined,
        baseColor: AppColors.sickLabel,
        backgroundColor: AppColors.sickBackground,
      );
    } else if (type.contains('casual')) {
      return const LeaveTheme(
        icon: Icons.work_outline,
        baseColor: AppColors.pending,
        backgroundColor: AppColors.pendingBackground,
      );
    } else if (type.contains('comp') || type.contains('off')) {
      return const LeaveTheme(
        icon: Icons.access_time,
        baseColor: AppColors.compLabel,
        backgroundColor: AppColors.compBackground,
      );
    } else if (type.contains('unpaid')) {
      return const LeaveTheme(
        icon: Icons.money_off,
        baseColor: AppColors.unpaidLabel,
        backgroundColor: AppColors.unpaidBackground, // Not transparent, to give it a background card
      );
    }

    // For dynamic types, assign a consistent theme based on the string hash
    final hash = leaveType.hashCode.abs();
    return _dynamicThemes[hash % _dynamicThemes.length];
  }
}
