import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:leave_management_app/core/constants/app_text_styles.dart';

class SchoolSettingsPage extends ConsumerWidget {
  const SchoolSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary, size: 28),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'School Settings',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w700,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text('General Settings', style: AppTextStyles.formLabel),
              const SizedBox(height: 16),
              _SettingsField(
                label: 'School Name',
                initialValue: 'Ananda College',
                icon: Icons.business_rounded,
              ),
              const SizedBox(height: 16),
              _SettingsField(
                label: 'Contact Email',
                initialValue: 'admin@ananda.edu',
                icon: Icons.email_outlined,
              ),
              const SizedBox(height: 32),
              
              const Text('Default Leave Quotas', style: AppTextStyles.formLabel),
              const SizedBox(height: 16),
              _SettingsField(
                label: 'Annual Leave (Days)',
                initialValue: '20',
                icon: Icons.wb_sunny_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _SettingsField(
                label: 'Sick Leave (Days)',
                initialValue: '14',
                icon: Icons.medical_services_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _SettingsField(
                label: 'Casual Leave (Days)',
                initialValue: '7',
                icon: Icons.event_available_outlined,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 48),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    // Handle save
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Settings saved successfully')),
                    );
                  },
                  child: const Text(
                    'Save Settings',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsField extends StatelessWidget {
  final String label;
  final String initialValue;
  final IconData icon;
  final TextInputType? keyboardType;

  const _SettingsField({
    required this.label,
    required this.initialValue,
    required this.icon,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: AppColors.textTertiary, size: 20),
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }
}
