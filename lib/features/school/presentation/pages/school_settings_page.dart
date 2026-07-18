import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:leave_management_app/core/constants/app_colors.dart';
import 'package:leave_management_app/core/constants/app_text_styles.dart';
import 'package:leave_management_app/features/school/presentation/providers/school_providers.dart';

class SchoolSettingsPage extends ConsumerWidget {
  const SchoolSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schoolAsync = ref.watch(currentSchoolProvider);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          context.go('/school/dashboard');
        }
      },
      child: Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary, size: 28),
          onPressed: () => context.go('/school/dashboard'),
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
        child: schoolAsync.when(
          data: (school) {
            if (school == null) return const Center(child: Text('School not found'));
            
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('General Settings', style: AppTextStyles.formLabel),
                  const SizedBox(height: 16),
                  _SettingsField(
                    label: 'School Name',
                    initialValue: school.name,
                    icon: Icons.business_rounded,
                  ),
                  const SizedBox(height: 16),
                  _SettingsField(
                    label: 'School Address',
                    initialValue: school.address,
                    icon: Icons.location_on_outlined,
                  ),
                  const SizedBox(height: 32),

                  const Text('Holiday Settings', style: AppTextStyles.formLabel),
                  const SizedBox(height: 16),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primarySubtle,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.event_available, color: AppColors.primary),
                    ),
                    title: const Text('Manage Public Holidays', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Add, edit or remove yearly holidays', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    trailing: const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiary),
                    onTap: () {
                      context.push('/school/holidays');
                    },
                  ),

                  const SizedBox(height: 32),
                  
                  const Text('Default Leave Quotas', style: AppTextStyles.formLabel),
                  const SizedBox(height: 16),
                  ...school.leavePolicies.entries.map((e) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _SettingsField(
                        label: '${e.key} (Days)',
                        initialValue: e.value.toString(),
                        icon: Icons.article_outlined,
                        keyboardType: TextInputType.number,
                      ),
                    );
                  }),

                  const SizedBox(height: 32),
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
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
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
