import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/weather_utils.dart';
import '../core/utils/error_handler.dart';
import '../model/daily_forecast_model.dart';
import '../model/hourly_forecast_model.dart';

class WeatherForecastViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = true;
  String? _error;
  List<HourlyForecast> _hourlyForecasts = [];
  List<DailyForecast> _dailyForecasts = [];
  String _currentLocation = AppConstants.availableLocations.first;
  bool _hasData = false;

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<HourlyForecast> get hourlyForecasts => _hourlyForecasts;
  List<DailyForecast> get dailyForecasts => _dailyForecasts;
  String get currentLocation => _currentLocation;
  bool get hasData => _hasData;

  WeatherForecastViewModel() {
    fetchWeatherForecast();
  }

  Future<void> fetchWeatherForecast([String? location]) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final locationToUse = location ?? _currentLocation;
      final weatherData = await _apiService.getWeatherData(locationToUse);

      _currentLocation = locationToUse;

      _hourlyForecasts = weatherData.forecast.hourly.take(12).map((hourly) {
        return HourlyForecast(
          time: hourly.time,
          icon: WeatherUtils.getIconFromCondition(hourly.condition),
          temperature: WeatherUtils.formatTemperature(hourly.temperature),
          condition: hourly.condition,
        );
      }).toList();

      _dailyForecasts = weatherData.forecast.daily.take(7).map((daily) {
        return DailyForecast(
          day: WeatherUtils.getDayInSpanish(daily.day),
          icon: WeatherUtils.getIconFromCondition(daily.condition),
          temperature: '${WeatherUtils.formatTemperature(daily.tempMax)} / ${WeatherUtils.formatTemperature(daily.tempMin)}',
          condition: daily.condition,
        );
      }).toList();

      _hasData = true;

    } catch (e) {
      _error = ErrorHandler.getErrorMessage(e);
      if (!_hasData) {
        _generateFallbackData();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _generateFallbackData() {
    _hourlyForecasts = List.generate(6, (index) {
      final hour = (DateTime.now().hour + index + 1) % 24;
      return HourlyForecast(
        time: '${hour.toString().padLeft(2, '0')}:00',
        icon: Icons.help_outline,
        temperature: '--°',
        condition: 'desconocido',
      );
    });

    _dailyForecasts = List.generate(5, (index) {
      final days = ['Hoy', 'Mañana', 'Mié', 'Jue', 'Vie'];
      return DailyForecast(
        day: days[index],
        icon: Icons.help_outline,
        temperature: '--° / --°',
        condition: 'desconocido',
      );
    });
  }

  void changeLocation(String location) {
    if (AppConstants.availableLocations.contains(location) && location != _currentLocation) {
      fetchWeatherForecast(location);
    }
  }

  void refresh() {
    fetchWeatherForecast();
  }
}