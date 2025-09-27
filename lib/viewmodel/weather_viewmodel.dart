import 'dart:async';
import 'package:flutter/material.dart';
import '../model/rain_level_model.dart';
// Se agrega el prefijo 'model' para resolver el conflicto de nombres.
import '../model/weather_model.dart' as model;
import '../utils/color_palette.dart';

class WeatherViewModel extends ChangeNotifier {
  // Se usan los tipos con prefijo donde sea necesario.
  model.TimeOfDay _currentTimeOfDay = model.TimeOfDay.dia;
  model.WeatherCondition _currentWeather = model.WeatherCondition.despejado;
  RainLevel _currentRainLevel = RainLevel.ligera;

  String _currentTemperature = "28°C";
  String _currentEmoji = "☀️";

  late Timer _timer;
  DateTime _now = DateTime.now();

  model.TimeOfDay get currentTimeOfDay => _currentTimeOfDay;
  model.WeatherCondition get currentWeather => _currentWeather;
  RainLevel get currentRainLevel => _currentRainLevel;
  String get currentTemperature => _currentTemperature;
  String get currentEmoji => _currentEmoji;

  WeatherViewModel() {
    _updateCurrentStatus(); // Inicializa los valores al crear el ViewModel
    // Timer para actualizar la hora real.
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _now = DateTime.now();
      _updateCurrentStatus(); // Vuelve a verificar el emoji por si la hora cambió
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // --- Lógica de control ---

  void cycleTimeOfDay() {
    final values = model.TimeOfDay.values;
    final nextIndex = (_currentTimeOfDay.index + 1) % values.length;
    _currentTimeOfDay = values[nextIndex];
    _updateCurrentStatus();
    notifyListeners();
  }

  void cycleWeatherCondition() {
    final values = model.WeatherCondition.values;
    final nextIndex = (_currentWeather.index + 1) % values.length;
    _currentWeather = values[nextIndex];
    _updateCurrentStatus();
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

  void _updateCurrentStatus() {
    // 1. Determina la Temperatura basada en el ciclo manual de Tiempo del Día
    switch (_currentTimeOfDay) {
      case model.TimeOfDay.manana:
    case model.TimeOfDay.dia:
      _currentTemperature = _currentWeather == model.WeatherCondition.despejado ? "28°C" : "24°C";
      break;
      case model.TimeOfDay.tarde:
        _currentTemperature = _currentWeather == model.WeatherCondition.despejado ? "26°C" : "22°C";
        break;
      case model.TimeOfDay.noche:
        _currentTemperature = _currentWeather == model.WeatherCondition.despejado ? "18°C" : "17°C";
        break;
    }
    if(_currentWeather == model.WeatherCondition.lluvioso) {
      _currentTemperature = "21°C";
    }

    // 2. Determina el Emoji basado en la hora REAL y la condición del clima
    int hour = _now.hour;
    // Es de noche entre las 7 PM (19:00) y las 5:30 AM (05:30)
    bool isNightTime = (hour >= 19) || (hour < 5) || (hour == 5 && _now.minute <= 30);

    switch (_currentWeather) {
      case model.WeatherCondition.despejado:
        _currentEmoji = isNightTime ? "🌙" : "☀️";
        break;
      case model.WeatherCondition.nublado:
        _currentEmoji = "☁️";
        break;
      case model.WeatherCondition.lluvioso:
        _currentEmoji = "🌧️";
        break;
    }
  }

  // --- Propiedades de la UI (Getters) ---

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

