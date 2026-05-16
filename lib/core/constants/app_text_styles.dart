import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Typography scale derived from the HTML template CSS.
class AppTextStyles {
  AppTextStyles._();

  // ── Top-bar (header) ─────────────────────────────────────────────
  static const TextStyle topBarTitle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnPrimary,
    height: 1.2,
  );

  static const TextStyle topBarSubtitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textOnPrimarySubtle,
  );

  // ── Card ─────────────────────────────────────────────────────────
  static const TextStyle cardTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle cardLink = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );

  // ── Balance ──────────────────────────────────────────────────────
  static const TextStyle balanceDays = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: AppColors.annualDays,
    height: 1.1,
  );

  static const TextStyle balanceLabel = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.annualLabel,
  );

  static const TextStyle balanceSub = TextStyle(
    fontSize: 10,
    color: AppColors.annualSub,
  );

  // ── Leave Item ───────────────────────────────────────────────────
  static const TextStyle leaveItemTitle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle leaveItemDate = TextStyle(
    fontSize: 10,
    color: AppColors.textTertiary,
  );

  // ── Status Pill ──────────────────────────────────────────────────
  static const TextStyle statusPill = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  // ── Quick Action ─────────────────────────────────────────────────
  static const TextStyle quickAction = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
    height: 1.2,
  );

  // ── Bottom Nav ───────────────────────────────────────────────────
  static const TextStyle bottomNavLabel = TextStyle(
    fontSize: 9,
    color: AppColors.textDisabled,
  );

  static const TextStyle bottomNavLabelActive = TextStyle(
    fontSize: 9,
    color: AppColors.primary,
    fontWeight: FontWeight.w500,
  );

  // ── Form ─────────────────────────────────────────────────────────
  static const TextStyle formLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  static const TextStyle formInput = TextStyle(
    fontSize: 13,
    color: AppColors.textPrimary,
  );

  static const TextStyle formHint = TextStyle(
    fontSize: 12,
    color: AppColors.textDisabled,
  );

  // ── Submit Button ────────────────────────────────────────────────
  static const TextStyle submitButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnPrimary,
  );

  // ── Stats ────────────────────────────────────────────────────────
  static const TextStyle statNumber = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: AppColors.annualDays,
  );

  static const TextStyle statLabel = TextStyle(
    fontSize: 10,
    color: AppColors.annualSub,
  );

  // ── Team Item ────────────────────────────────────────────────────
  static const TextStyle teamName = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle teamRole = TextStyle(
    fontSize: 10,
    color: AppColors.textTertiary,
  );

  // ── Team Status Pill ─────────────────────────────────────────────
  static const TextStyle teamStatus = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w500,
  );

  // ── Manager Pending Card ─────────────────────────────────────────
  static const TextStyle pendingCardName = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w500,
    color: AppColors.textPrimary,
  );

  static const TextStyle pendingCardType = TextStyle(
    fontSize: 10,
    color: AppColors.textTertiary,
  );

  static const TextStyle pendingCardDates = TextStyle(
    fontSize: 11,
    color: AppColors.textSecondary,
  );

  static const TextStyle pendingCardReason = TextStyle(
    fontSize: 11,
    color: AppColors.textSecondary,
  );

  // ── Section Label ────────────────────────────────────────────────
  static const TextStyle sectionLabel = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: AppColors.textTertiary,
    letterSpacing: 0.05 * 11,
  );

  // ── Badge ────────────────────────────────────────────────────────
  static const TextStyle badge = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnPrimary,
  );

  // ── Calendar ─────────────────────────────────────────────────────
  static const TextStyle calDayHeader = TextStyle(
    fontSize: 9,
    fontWeight: FontWeight.w500,
    color: AppColors.calendarDayHeader,
  );

  static const TextStyle calDay = TextStyle(
    fontSize: 11,
    color: AppColors.textPrimary,
  );

  static const TextStyle calLegend = TextStyle(
    fontSize: 10,
    color: AppColors.textSecondary,
  );

  // ── Avatar ───────────────────────────────────────────────────────
  static const TextStyle avatarInitials = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textOnPrimary,
  );
}
