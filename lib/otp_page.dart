import 'package:flutter/material.dart';
import 'ui_theme.dart';
import 'change_password_page.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  int _seconds = 30;
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Ticker(_onTick)..start();
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    if (_seconds == 0) return;
    setState(() {
      _seconds = 30 - elapsed.inSeconds.clamp(0, 30);
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              const Text(
                'Enter OTP',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text(
                'We sent a 6-digit code to your gmail',
                style: TextStyle(color: AppColors.textMuted, fontSize: 16),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('One-Time Passcode', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (i) => _otpBox(_controllers[i])),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _seconds > 0 ? '00:${_seconds.toString().padLeft(2, '0')}' : '00:00',
                          style: const TextStyle(color: AppColors.textMuted),
                        ),
                        TextButton(
                          onPressed: _seconds == 0
                              ? () {
                                  setState(() {
                                    _seconds = 30;
                                    _ticker.start();
                                  });
                                }
                              : null,
                          child: const Text('Resend Code', style: TextStyle(color: AppColors.brandGreen)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _infoBanner(
                      icon: Icons.access_time,
                      text: "OTP expires in 10 minutes. Don't share it with anyone.",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.brandGreen,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  child: const Text('Verify & Continue', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
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

  Widget _otpBox(TextEditingController c) {
    return SizedBox(
      width: 44,
      child: TextField(
        controller: c,
        textAlign: TextAlign.center,
        maxLength: 1,
        keyboardType: TextInputType.number,
        decoration: roundedInputDecoration().copyWith(counterText: ''),
        onChanged: (v) {
          if (v.isNotEmpty) FocusScope.of(context).nextFocus();
        },
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

  void _verify() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ChangePasswordPage()),
    );
  }
}

class Ticker {
  Ticker(this.onTick);
  final void Function(Duration) onTick;
  Duration _elapsed = Duration.zero;
  bool _running = false;

  void start() {
    if (_running) return;
    _running = true;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (!_running) return false;
      _elapsed += const Duration(seconds: 1);
      onTick(_elapsed);
      return _running;
    });
  }

  void dispose() {
    _running = false;
  }
}


