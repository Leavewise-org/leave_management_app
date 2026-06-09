import 'package:flutter/material.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';

class AppRefreshIndicator extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const AppRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppColors.primary,
      backgroundColor: Colors.white,
      onRefresh: () async {
        // Run the refresh logic
        await onRefresh();
        // Add a slight delay so the spinner animation finishes gracefully
        await Future.delayed(const Duration(milliseconds: 500));
      },
      child: child,
    );
  }
}
