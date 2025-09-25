import 'package:flutter/material.dart';
import 'ui_theme.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _p1 = TextEditingController();
  final TextEditingController _p2 = TextEditingController();
  bool _v1 = false;
  bool _v2 = false;

  @override
  void dispose() {
    _p1.dispose();
    _p2.dispose();
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
              const Text('Sign in to continue to your Ai assistant', style: TextStyle(color: AppColors.textMuted, fontSize: 16)),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                  onPressed: _reset,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  child: const Text('Reset', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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

  void _reset() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password reset')));
      Navigator.of(context).popUntil((r) => r.isFirst);
    }
  }
}


