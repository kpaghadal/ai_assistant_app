import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ui_theme.dart';
import 'login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  final String? email;
  
  const ChangePasswordPage({super.key, this.email});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _p1 = TextEditingController();
  final TextEditingController _p2 = TextEditingController();
  final TextEditingController _currentPasswordController = TextEditingController();
  bool _v1 = false;
  bool _v2 = false;
  bool _v3 = false;
  bool _isLoading = false;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    _p1.dispose();
    _p2.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintBackground,
      appBar: const AppHeader(title: 'Ai Assistant App'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 8),
              const Text('Change Password', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(
                widget.email != null
                    ? 'Set a new password for ${widget.email}'
                    : 'Enter your new password',
                style: const TextStyle(color: AppColors.textMuted, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Show current password field only if user is logged in
                      if (_auth.currentUser != null) ...[
                        const Text('Current Password', style: TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _currentPasswordController,
                          obscureText: !_v3,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Enter current password';
                            return null;
                          },
                          decoration: roundedInputDecoration(
                            hint: 'Enter current password',
                            prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted),
                            suffixIcon: IconButton(
                              icon: Icon(_v3 ? Icons.visibility : Icons.visibility_off),
                              onPressed: () => setState(() => _v3 = !_v3),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      const Text('New password', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _p1,
                        obscureText: !_v1,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Enter new password';
                          if (v.length < 6) return 'At least 6 characters';
                          return null;
                        },
                        decoration: roundedInputDecoration(
                          hint: 'Enter new password',
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted),
                          suffixIcon: IconButton(
                            icon: Icon(_v1 ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _v1 = !_v1),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Confirm Password', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _p2,
                        obscureText: !_v2,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Re-enter password';
                          if (v != _p1.text) return 'Passwords do not match';
                          return null;
                        },
                        decoration: roundedInputDecoration(
                          hint: 'Re-enter a password',
                          prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textMuted),
                          suffixIcon: IconButton(
                            icon: Icon(_v2 ? Icons.visibility : Icons.visibility_off),
                            onPressed: () => setState(() => _v2 = !_v2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _infoBanner(),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('Reset Password', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                child: const Text('Back To Login', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: const Color(0xFFA7D9B8), borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: const [
          Icon(Icons.shield_outlined, color: Colors.black87),
          SizedBox(width: 12),
          Expanded(
            child: Text('We keep your information secure with industry-standard encryption.',
                style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _reset() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);

    try {
      final newPassword = _p1.text.trim();
      final user = _auth.currentUser;

      if (user != null) {
        // User is logged in - verify current password first
        final currentPassword = _currentPasswordController.text.trim();
        if (currentPassword.isEmpty) {
          throw Exception('Please enter your current password');
        }

        // Re-authenticate user
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);

        // Update password
        await user.updatePassword(newPassword);
      } else if (widget.email != null) {
        // User is resetting password via email link
        // They should have clicked the link in email, which signs them in
        // If not signed in, we need to sign them in first
        // For security, we'll show a message to use the email link
        throw Exception(
          'Please click the password reset link sent to your email first. '
          'If you haven\'t received it, check your spam folder or request a new one.'
        );
      } else {
        throw Exception('No user session found');
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to login page
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message = 'Failed to update password';
      if (e.code == 'wrong-password') {
        message = 'Current password is incorrect';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'requires-recent-login') {
        message = 'Please log out and log in again before changing password';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }
}


