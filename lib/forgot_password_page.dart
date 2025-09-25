import 'package:flutter/material.dart';
import 'ui_theme.dart';
import 'otp_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
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
              const Text(
                'Forgot Password',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your email to receive a one-time code',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textMuted, fontSize: 16),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Email', style: TextStyle(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _email,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) {
                          if (v == null || v.isEmpty) return 'Please enter your email';
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(v)) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                        decoration: roundedInputDecoration(
                          hint: 'Enter your Email',
                          prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textMuted),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _infoBanner(
                        icon: Icons.access_time,
                        text: "OTP expires in 10 minutes. Don't share it with anyone.",
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _sendOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  child: const Text('Send OTP', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back To Login', style: TextStyle(color: Color(0xFF3B82F6), fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoBanner({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFA7D9B8),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black87),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _sendOtp() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const OtpPage()),
      );
    }
  }
}


