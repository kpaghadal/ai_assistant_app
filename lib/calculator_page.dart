import 'package:flutter/material.dart';
import 'package:flutter_simple_calculator/flutter_simple_calculator.dart';
import 'ui_theme.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key});

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  double _value = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintBackground,
      appBar: const AppHeader(title: 'AI Assistant App', showBack: true),
      body: Column(
        children: [
          // 🔹 Title section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: const [
                SizedBox(height: 4),
                Text('Calculator',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                SizedBox(height: 12),
                Divider(height: 1, color: Color(0xFFBFD7C7)),
              ],
            ),
          ),

          // 🔹 Calculator Section
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: SimpleCalculator(
                    value: _value,
                    hideExpression: false,
                    hideSurroundingBorder: true,
                    theme: const CalculatorThemeData(
                      displayColor: Color(0xFFE6F4EA),
                      displayStyle: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      commandColor: Color.fromARGB(255, 190, 204, 202),
                      commandStyle: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      operatorColor: Color.fromARGB(255, 190, 204, 202),
                      operatorStyle: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      numColor: Colors.white,
                      numStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                      ),
                    ),
                    onChanged: (key, value, expression) {
                      setState(() {
                        _value = value ?? 0;
                      });
                    },
                  ),
                ),
              ),
            ),
          ),

          // 🔹 Bottom navigation bar
          _bottomNavMock(),
        ],
      ),
    );
  }

  Widget _bottomNavMock() {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: Color(0xFFF0F5F1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _NavIcon(icon: Icons.home_outlined),
          
          _NavIcon(icon: Icons.settings_outlined),
        ],
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  const _NavIcon({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Icon(icon, size: 28, color: Colors.black87);
  }
}
