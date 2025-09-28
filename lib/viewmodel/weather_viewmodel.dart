import 'dart:async';
import 'package:flutter/material.dart';
import '../core/services/api_service.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/weather_utils.dart';
import '../core/utils/error_handler.dart';
import '../model/rain_level_model.dart';
import '../model/weather_model.dart' as model;
import '../utils/color_palette.dart';

class WeatherViewModel extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  model.TimeOfDay _currentTimeOfDay = model.TimeOfDay.dia;
  model.WeatherCondition _currentWeather = model.WeatherCondition.despejado;
  RainLevel _currentRainLevel = RainLevel.ligera;

  double _currentTemperature = 28.0;
  String _currentCondition = "despejado";
  String _currentLocation = AppConstants.availableLocations.first;
  bool _isLoading = false;
  String? _error;
  bool _hasData = false;

  // Nuevo estado para la animación
  bool _isTimeAccelerated = false;

  late Timer _timer;

  model.TimeOfDay get currentTimeOfDay => _currentTimeOfDay;
  model.WeatherCondition get currentWeather => _currentWeather;
  RainLevel get currentRainLevel => _currentRainLevel;
  String get currentTemperature => WeatherUtils.formatTemperature(_currentTemperature);
  String get currentEmoji => WeatherUtils.getEmojiFromCondition(_currentCondition, isNight: WeatherUtils.isNightTime());
  String get currentLocation => _currentLocation;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasData => _hasData;
  // Getter para el nuevo estado
  bool get isTimeAccelerated => _isTimeAccelerated;

  WeatherViewModel() {
    _loadWeatherData();
    _timer = Timer.periodic(AppConstants.refreshInterval, (timer) {
      if (_hasData) {
        _loadWeatherData();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _loadWeatherData() async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      final weatherData = await _apiService.getWeatherData(_currentLocation);

      _currentTemperature = weatherData.current.temperature;
      _currentCondition = weatherData.current.condition;
      _currentWeather = WeatherUtils.mapConditionToEnum(_currentCondition);
      _currentRainLevel = WeatherUtils.mapConditionToRainLevel(_currentCondition);
      _hasData = true;

      _updateTimeOfDayFromHour();

    } catch (e) {
      _error = ErrorHandler.getErrorMessage(e);
      if (!_hasData) {
        _setDefaultValues();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _setDefaultValues() {
    _currentTemperature = 25.0;
    _currentCondition = "despejado";
    _currentWeather = model.WeatherCondition.despejado;
    _currentRainLevel = RainLevel.ligera;
    _updateTimeOfDayFromHour();
  }

  void _updateTimeOfDayFromHour() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      _currentTimeOfDay = model.TimeOfDay.manana;
    } else if (hour >= 12 && hour < 18) {
      _currentTimeOfDay = model.TimeOfDay.dia;
    } else if (hour >= 18 && hour < 21) {
      _currentTimeOfDay = model.TimeOfDay.tarde;
    } else {
      _currentTimeOfDay = model.TimeOfDay.noche;
    }
  }

  void setWeatherFromForecast(model.WeatherCondition condition, RainLevel rainLevel) {
    _currentWeather = condition;
    _currentRainLevel = rainLevel;
    notifyListeners();
  }

  void cycleTimeOfDay() {
    final values = model.TimeOfDay.values;
    final nextIndex = (_currentTimeOfDay.index + 1) % values.length;
    _currentTimeOfDay = values[nextIndex];
    // Activa la animación acelerada
    _isTimeAccelerated = true;
    notifyListeners();
  }

  void cycleWeatherCondition() {
    final values = model.WeatherCondition.values;
    final nextIndex = (_currentWeather.index + 1) % values.length;
    _currentWeather = values[nextIndex];
    notifyListeners();
  }

  void cycleRainLevel() {
    if (_currentWeather == model.WeatherCondition.lluvioso) {
      final values = RainLevel.values;
      final nextIndex = (_currentRainLevel.index + 1) % values.length;
      _currentRainLevel = values[nextIndex];
      notifyListeners();
    }
  }

  void changeLocation(String location) {
    if (AppConstants.availableLocations.contains(location) && location != _currentLocation) {
      _currentLocation = location;
      // Restaura la animación al cambiar de ubicación
      _isTimeAccelerated = false;
      _loadWeatherData();
    }
  }

  void refresh() {
    // Restaura la animación al actualizar
    _isTimeAccelerated = false;
    _loadWeatherData();
  }

  Gradient get backgroundGradient {
    if (_currentWeather == model.WeatherCondition.lluvioso) {
      return ColorPalette.rainyGradient;
    }
    switch (_currentTimeOfDay) {
      case model.TimeOfDay.manana:
        return ColorPalette.sunriseGradient;
      case model.TimeOfDay.dia:
        return ColorPalette.dayGradient;
      case model.TimeOfDay.tarde:
        return ColorPalette.sunsetGradient;
      case model.TimeOfDay.noche:
        return ColorPalette.nightGradient;
    }
  }

  double get backgroundOpacity {
    if (_currentWeather == model.WeatherCondition.nublado) return 0.7;
    if (_currentWeather == model.WeatherCondition.lluvioso) return 0.5;
    return 1.0;
  }

  bool get showStars {
    return _currentTimeOfDay == model.TimeOfDay.noche &&
        _currentWeather == model.WeatherCondition.despejado;
  }
}