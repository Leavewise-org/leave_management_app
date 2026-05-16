import 'package:flutter/material.dart';

/// Color palette extracted from the HTML design template.
/// All colors are referenced directly from the CSS variables.
class AppColors {
  AppColors._();

  // ── Brand / Primary ──────────────────────────────────────────────
  static const Color primary = Color(0xFF185FA5);
  static const Color primaryLight = Color(0xFF378ADD);
  static const Color primarySubtle = Color(0xFFE6F1FB);
  static const Color primaryText = Color(0xFF0C447C);

  // ── Background ───────────────────────────────────────────────────
  static const Color scaffoldBackground = Color(0xFFF0F4F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color topBar = Color(0xFF185FA5);

  // ── Text ─────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF2C2C2A);
  static const Color textSecondary = Color(0xFF5F5E5A);
  static const Color textTertiary = Color(0xFF888780);
  static const Color textDisabled = Color(0xFFB4B2A9);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnPrimarySubtle = Color(0xFFB5D4F4);

  // ── Border ───────────────────────────────────────────────────────
  static const Color border = Color(0xFFD3D1C7);
  static const Color borderLight = Color(0xFFF1EFE8);

  // ── Status ───────────────────────────────────────────────────────
  static const Color approved = Color(0xFF1D9E75);
  static const Color approvedBackground = Color(0xFFE1F5EE);
  static const Color approvedText = Color(0xFF0F6E56);

  static const Color pending = Color(0xFFEF9F27);
  static const Color pendingBackground = Color(0xFFFAEEDA);
  static const Color pendingText = Color(0xFF854F0B);

  static const Color rejected = Color(0xFFE24B4A);
  static const Color rejectedBackground = Color(0xFFFCEBEB);
  static const Color rejectedText = Color(0xFFA32D2D);

  // ── Leave Types ──────────────────────────────────────────────────
  // Annual
  static const Color annualBackground = Color(0xFFE6F1FB);
  static const Color annualLabel = Color(0xFF185FA5);
  static const Color annualDays = Color(0xFF0C447C);
  static const Color annualSub = Color(0xFF378ADD);

  // Sick
  static const Color sickBackground = Color(0xFFE1F5EE);
  static const Color sickLabel = Color(0xFF0F6E56);
  static const Color sickDays = Color(0xFF085041);
  static const Color sickSub = Color(0xFF1D9E75);

  // Comp Off
  static const Color compBackground = Color(0xFFFAEEDA);
  static const Color compLabel = Color(0xFF854F0B);
  static const Color compDays = Color(0xFF633806);

  // Unpaid
  static const Color unpaidBackground = Color(0xFFF1EFE8);
  static const Color unpaidLabel = Color(0xFF5F5E5A);
  static const Color unpaidDays = Color(0xFF444441);

  // ── Team Avatars ─────────────────────────────────────────────────
  static const Color avatarBlue = Color(0xFF378ADD);
  static const Color avatarTeal = Color(0xFF1D9E75);
  static const Color avatarCoral = Color(0xFFD85A30);
  static const Color avatarPurple = Color(0xFF7F77DD);

  // ── Quick Actions ─────────────────────────────────────────────────
  static const Color quickBlueBackground = Color(0xFFE6F1FB);
  static const Color quickGreenBackground = Color(0xFFEAF3DE);
  static const Color quickGreenText = Color(0xFF3B6D11);
  static const Color quickAmberBackground = Color(0xFFFAEEDA);
  static const Color quickGrayBackground = Color(0xFFF1EFE8);

  // ── Calendar ─────────────────────────────────────────────────────
  static const Color calendarToday = Color(0xFF185FA5);
  static const Color calendarLeave = Color(0xFFE6F1FB);
  static const Color calendarHoliday = Color(0xFFFAEEDA);
  static const Color calendarHolidayText = Color(0xFF854F0B);
  static const Color calendarDayHeader = Color(0xFFB4B2A9);

  // ── Manager Pending Card ─────────────────────────────────────────
  static const Color pendingCardBorder = Color(0xFFEF9F27);
  static const Color approveButtonBg = Color(0xFFE1F5EE);
  static const Color approveButtonText = Color(0xFF0F6E56);
  static const Color rejectButtonBg = Color(0xFFFCEBEB);
  static const Color rejectButtonText = Color(0xFFA32D2D);

  // ── Misc ─────────────────────────────────────────────────────────
  static const Color notifBadge = Color(0xFFE24B4A);
  static const Color shimmerBase = Color(0xFFE0E0E0);
  static const Color shimmerHighlight = Color(0xFFF5F5F5);
}
