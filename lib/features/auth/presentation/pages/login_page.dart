import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/router/app_router.dart';
import '../providers/auth_provider.dart';

/// Login page — matches the design style extracted from the HTML template:
/// • Blue top section with school branding
/// • White card with email/password fields
/// • Loading state with spinner inside the button
/// • Inline error banner for auth failures
class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    ref.read(signInNotifierProvider.notifier).clearError();
    if (!_formKey.currentState!.validate()) return;

    await ref.read(signInNotifierProvider.notifier).signIn(
          email: _emailCtrl.text.trim(),
          password: _passCtrl.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final signInState = ref.watch(signInNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Column(
        children: [
          // ── Blue top header ───────────────────────────────────────
          _TopHeader(),

          // ── Login card ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Error banner
                  if (signInState.failure != null) ...[
                    _ErrorBanner(message: signInState.failure!.message),
                    const SizedBox(height: 16),
                  ],

                  // Form card
                  _FormCard(
                    formKey: _formKey,
                    emailCtrl: _emailCtrl,
                    passCtrl: _passCtrl,
                    obscurePass: _obscurePass,
                    onTogglePassword: () =>
                        setState(() => _obscurePass = !_obscurePass),
                  ),

                  const SizedBox(height: 8),

                  // Forgot password
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {}, // TODO: forgot password flow
                      child: const Text(
                        AppStrings.forgotPassword,
                        style: AppTextStyles.cardLink,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Submit button
                  _SubmitButton(
                    isLoading: signInState.isLoading,
                    onPressed: _submit,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _TopHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Status bar height
    final topPad = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, topPad + 24, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.topBar,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // School icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.school_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 16),
          const Text('Leave Manager', style: AppTextStyles.topBarTitle),
          const SizedBox(height: 4),
          const Text(
            'Sign in to your school account',
            style: AppTextStyles.topBarSubtitle,
          ),
        ],
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  const _FormCard({
    required this.formKey,
    required this.emailCtrl,
    required this.passCtrl,
    required this.obscurePass,
    required this.onTogglePassword,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailCtrl;
  final TextEditingController passCtrl;
  final bool obscurePass;
  final VoidCallback onTogglePassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Email
            const Text(AppStrings.email, style: AppTextStyles.formLabel),
            const SizedBox(height: 4),
            TextFormField(
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              style: AppTextStyles.formInput,
              decoration: const InputDecoration(
                hintText: AppStrings.emailHint,
                prefixIcon: Icon(Icons.email_outlined,
                    size: 18, color: AppColors.textTertiary),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return AppStrings.fieldRequired;
                }
                if (!v.contains('@')) return AppStrings.invalidEmail;
                return null;
              },
            ),

            const SizedBox(height: 14),

            // Password
            const Text(AppStrings.password, style: AppTextStyles.formLabel),
            const SizedBox(height: 4),
            TextFormField(
              controller: passCtrl,
              obscureText: obscurePass,
              textInputAction: TextInputAction.done,
              style: AppTextStyles.formInput,
              decoration: InputDecoration(
                hintText: AppStrings.passwordHint,
                prefixIcon: const Icon(Icons.lock_outline_rounded,
                    size: 18, color: AppColors.textTertiary),
                suffixIcon: IconButton(
                  icon: Icon(
                    obscurePass
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 18,
                    color: AppColors.textTertiary,
                  ),
                  onPressed: onTogglePassword,
                ),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return AppStrings.fieldRequired;
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(AppStrings.signIn),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});
  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.rejectedBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.rejected.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline_rounded,
              size: 16, color: AppColors.rejectedText),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTextStyles.formLabel
                  .copyWith(color: AppColors.rejectedText),
            ),
          ),
        ],
      ),
    );
  }
}
