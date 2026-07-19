import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class JoinSchoolPage extends ConsumerStatefulWidget {
  const JoinSchoolPage({super.key});

  @override
  ConsumerState<JoinSchoolPage> createState() => _JoinSchoolPageState();
}

class _JoinSchoolPageState extends ConsumerState<JoinSchoolPage> {
  final _joinFormKey = GlobalKey<FormState>();
  final _joinIdCtrl = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _joinIdCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleJoin() async {
    if (!_joinFormKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
    });

    try {
      await ref
          .read(authRepositoryProvider)
          .joinOrganization(_joinIdCtrl.text.trim());
      // The router should automatically redirect upon Firestore update
    } catch (e) {
      if (mounted) {
        final errorText = e.toString().replaceAll('Exception: ', '');
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              errorText,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.rejected,
            behavior: SnackBarBehavior.fixed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: AppBar(
        title: const Text(
          'Join School',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: AppColors.scaffoldBackground,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Join an Existing School',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter the Organization ID provided by your Principal.',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 32),
              
              Form(
                key: _joinFormKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Organization ID',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _joinIdCtrl,
                      decoration: InputDecoration(
                        hintText: 'e.g. ananda-college',
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary),
                        ),
                      ),
                      validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        onPressed: _isLoading ? null : _handleJoin,
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Join School',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
