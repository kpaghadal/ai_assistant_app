import 'package:flutter/material.dart';
import 'package:weather/weather.dart';
import 'ui_theme.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final TextEditingController _cityController = TextEditingController();
  WeatherFactory? _weatherFactory;
  Weather? _weather;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _weatherFactory =
        WeatherFactory('f779abd641c4f5c90b4a4d9cf87c6756', language: Language.ENGLISH);
  }

  Future<void> _fetchWeather() async {
    String city = _cityController.text.trim();
    if (city.isEmpty) return;

    setState(() {
      _isLoading = true;
      _weather = null;
    });

    try {
      Weather weather = await _weatherFactory!.currentWeatherByCityName(city);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('City not found or error fetching weather')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mintBackground,
      appBar: const AppHeader(title: 'Ai Assistat App', showBack: true),
      body: Column(
        children: [
          // Title section
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Column(
              children: const [
                SizedBox(height: 4),
                Text('Weather', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
                SizedBox(height: 12),
                Divider(height: 1, color: Color(0xFFBFD7C7)),
              ],
            ),
          ),

          // Input field
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      hintText: 'Enter city name...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onSubmitted: (_) => _fetchWeather(),
                  ),
                ),
                const SizedBox(width: 8),
                SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _fetchWeather,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.brandGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Icon(Icons.search, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          // Weather result
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _weather != null
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                _weather!.areaName ?? '',
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${_weather!.temperature?.celsius?.toStringAsFixed(1) ?? '-'}°C',
                                style: const TextStyle(
                                    fontSize: 48, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _weather!.weatherDescription ?? '',
                                style: const TextStyle(
                                    fontSize: 18, color: AppColors.textMuted),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  _weatherInfoItem('Humidity',
                                      '${_weather!.humidity ?? '-'}%'),
                                  _weatherInfoItem(
                                      'Wind', '${_weather!.windSpeed ?? '-'} m/s'),
                                  _weatherInfoItem(
                                      'Pressure', '${_weather!.pressure ?? '-'} hPa'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
          ),

          // Bottom navigation mock
          _bottomNavMock(),
        ],
      ),
    );
  }

  Widget _weatherInfoItem(String title, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: AppColors.textMuted)),
      ],
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
