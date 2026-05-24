import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:leave_management_app/core/constants/app_text_styles.dart';

class SystemSettingsPage extends ConsumerWidget {
  const SystemSettingsPage({super.key});

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
          'System Settings',
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
              const Text('Global Defaults', style: AppTextStyles.formLabel),
              const SizedBox(height: 16),
              _SettingsField(
                label: 'Default Admin Quota (Annual)',
                initialValue: '20',
                icon: Icons.shield_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _SettingsField(
                label: 'Max Employees per School',
                initialValue: '1000',
                icon: Icons.groups_outlined,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 32),
              
              const Text('System Information', style: AppTextStyles.formLabel),
              const SizedBox(height: 16),
              const _InfoRow(label: 'Platform Version', value: 'v1.2.4 (Build 42)'),
              const _InfoRow(label: 'API Endpoint', value: 'https://api.leavewise.app/v1'),
              const _InfoRow(label: 'Environment', value: 'Production'),
              
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('System settings saved successfully')),
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
            fillColor: AppColors.scaffoldBackground,
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

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
