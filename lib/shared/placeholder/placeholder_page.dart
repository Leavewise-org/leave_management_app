import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_text_styles.dart';

/// Temporary placeholder — replace with the real page widget once built.
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        backgroundColor: AppColors.topBar,
        title: Text(label, style: AppTextStyles.topBarTitle),
        elevation: 0,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.construction_rounded,
                color: AppColors.primary, size: 48),
            const SizedBox(height: 16),
            Text(
              label,
              style: AppTextStyles.cardTitle.copyWith(fontSize: 16),
            ),
            const SizedBox(height: 6),
            Text(
              'Coming soon',
              style: AppTextStyles.leaveItemDate,
            ),
            const SizedBox(height: 32),
            // ── Temp logout button for testing ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 46),
              child: ElevatedButton.icon(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text('Sign Out (test)'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.rejected,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
