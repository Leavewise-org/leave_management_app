import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';

class StatusPill extends StatelessWidget {
  final String status;

  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color textColor;
    Color bgColor;

    switch (status.toLowerCase()) {
      case 'approved':
        textColor = AppColors.approvedText;
        bgColor = AppColors.approvedBackground;
        break;
      case 'pending':
        textColor = AppColors.pendingText;
        bgColor = AppColors.pendingBackground;
        break;
      case 'rejected':
        textColor = AppColors.rejectedText;
        bgColor = AppColors.rejectedBackground;
        break;
      default:
        textColor = AppColors.textTertiary;
        bgColor = AppColors.borderLight;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        status.toUpperCase(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.bold,
          color: textColor,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
