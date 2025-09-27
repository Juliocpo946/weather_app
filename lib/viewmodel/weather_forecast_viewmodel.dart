import 'dart:math';
import 'package:flutter/material.dart';
import '../model/daily_forecast_model.dart';
import '../model/hourly_forecast_model.dart';

class WeatherForecastViewModel extends ChangeNotifier {
  bool _isLoading = true;
  List<HourlyForecast> _hourlyForecasts = [];
  List<DailyForecast> _dailyForecasts = [];

  bool get isLoading => _isLoading;
  List<HourlyForecast> get hourlyForecasts => _hourlyForecasts;
  List<DailyForecast> get dailyForecasts => _dailyForecasts;

  WeatherForecastViewModel() {
    fetchWeatherForecast();
  }

  // Simula una llamada a una API de clima.
  Future<void> fetchWeatherForecast() async {
    _isLoading = true;
    notifyListeners();

    // Simula una espera de red de 2 segundos.
    await Future.delayed(const Duration(seconds: 2));

    // --- AQUÍ IRÍA TU LÓGICA DE PETICIÓN HTTP REAL ---
    // final response = await http.get(Uri.parse('https://api.weather.com/...'));
    // final data = json.decode(response.body);
    // -------------------------------------------------

    // Generamos datos de ejemplo.
    _generateMockData();

    _isLoading = false;
    notifyListeners();
  }

  void _generateMockData() {
    final random = Random();
    final icons = [Icons.wb_sunny, Icons.cloud, Icons.grain, Icons.thunderstorm];

    _hourlyForecasts = List.generate(12, (index) {
      final hour = TimeOfDay.now().hour + index + 1;
      return HourlyForecast(
        time: '${hour % 24}:00',
        icon: icons[random.nextInt(icons.length)],
        temperature: '${18 + random.nextInt(10)}°',
      );
    });

    final days = ['Mañana', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom', 'Lun'];
    _dailyForecasts = List.generate(7, (index) {
      return DailyForecast(
        day: days[index],
        icon: icons[random.nextInt(icons.length)],
        temperature: '${20 + random.nextInt(8)}° / ${10 + random.nextInt(7)}°',
      );
    });
  }
}
