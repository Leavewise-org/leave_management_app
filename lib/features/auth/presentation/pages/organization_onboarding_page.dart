import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/auth_provider.dart';

class OrganizationOnboardingPage extends ConsumerStatefulWidget {
  const OrganizationOnboardingPage({super.key});

  @override
  ConsumerState<OrganizationOnboardingPage> createState() =>
      _OrganizationOnboardingPageState();
}

class _OrganizationOnboardingPageState
    extends ConsumerState<OrganizationOnboardingPage> {
  final _joinFormKey = GlobalKey<FormState>();
  final _createFormKey = GlobalKey<FormState>();

  final _joinIdCtrl = TextEditingController();
  final _createNameCtrl = TextEditingController();
  final _createAddressCtrl = TextEditingController();

  bool _isLoading = false;
  String? _errorMsg;

  @override
  void dispose() {
    _joinIdCtrl.dispose();
    _createNameCtrl.dispose();
    _createAddressCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleJoin() async {
    if (!_joinFormKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      await ref
          .read(authRepositoryProvider)
          .joinOrganization(_joinIdCtrl.text.trim());
      // The router should automatically redirect upon Firestore update
    } catch (e) {
      if (mounted) setState(() => _errorMsg = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _handleCreate() async {
    if (!_createFormKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      await ref.read(authRepositoryProvider).createOrganization(
            _createNameCtrl.text.trim(),
            _createAddressCtrl.text.trim(),
          );
      // Router will automatically redirect to admin dashboard
    } catch (e) {
      if (mounted) setState(() => _errorMsg = e.toString());
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Setup Organization'),
        centerTitle: true,
        backgroundColor: AppColors.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authRepositoryProvider).signOut(),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_errorMsg != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.rejectedBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _errorMsg!,
                    style: const TextStyle(color: AppColors.rejectedText),
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              // JOIN SECTION
              const Text(
                'Join an Existing School',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter the Organization ID provided by your Principal.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Form(
                key: _joinFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _joinIdCtrl,
                      decoration: InputDecoration(
                        labelText: 'Organization ID',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handleJoin,
                        child: const Text('Join School'),
                      ),
                    ),
                  ],
                ),
              ),
              
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 32.0),
                child: Divider(),
              ),

              // CREATE SECTION
              const Text(
                'Register a New School',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Are you a Principal or Owner? Register your school here.',
                style: TextStyle(color: AppColors.textSecondary),
              ),
              const SizedBox(height: 16),
              Form(
                key: _createFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _createNameCtrl,
                      decoration: InputDecoration(
                        labelText: 'School Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _createAddressCtrl,
                      decoration: InputDecoration(
                        labelText: 'School Address',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      validator: (v) => v!.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _isLoading ? null : _handleCreate,
                        child: const Text('Register New School'),
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
