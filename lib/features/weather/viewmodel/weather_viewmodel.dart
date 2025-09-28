import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/weather_service_interface.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/weather_utils.dart';
import '../../../core/utils/error_handler.dart';
import '../model/weather_state_model.dart';
import '../model/rain_level_model.dart';
import '../model/weather_model.dart' as model;
import '../model/forecast_model.dart';
import '../utils/color_palette.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherServiceInterface _weatherService = ApiService();
  WeatherState _state = WeatherState.initial();
  late Timer _refreshTimer;

  // Getters públicos (acceso directo al estado)
  WeatherState get state => _state;
  model.TimeOfDay get currentTimeOfDay => _state.currentTimeOfDay;
  model.WeatherCondition get currentWeather => _state.currentWeather;
  RainLevel get currentRainLevel => _state.currentRainLevel;
  String get currentTemperature => _state.formattedTemperature;
  String get currentEmoji => _state.currentEmoji;
  String get currentLocation => _state.currentLocation;
  bool get isLoading => _state.isLoading;
  String? get error => _state.error;
  bool get hasData => _state.hasData;
  bool get isTimeAccelerated => _state.isTimeAccelerated;
  List<Forecast> get hourlyForecasts => _state.hourlyForecasts;
  List<Forecast> get dailyForecasts => _state.dailyForecasts;
  bool get showStars => _state.showStars;
  double get backgroundOpacity => _state.backgroundOpacity;

  WeatherViewModel() {
    _initializeTimer();
    _loadAllWeatherData();
  }

  void _initializeTimer() {
    _refreshTimer = Timer.periodic(AppConstants.refreshInterval, (timer) {
      if (_state.hasData) {
        _loadAllWeatherData();
      }
    });
  }

  @override
  void dispose() {
    _refreshTimer.cancel();
    super.dispose();
  }

  // Métodos de carga de datos
  Future<void> _loadAllWeatherData() async {
    await _loadCurrentWeather();
    await _loadWeatherForecast();
  }

  Future<void> _loadCurrentWeather() async {
    try {
      _updateState(isLoading: true, error: null);

      final weatherData = await _weatherService.getWeatherData(_state.currentLocation);
      final weatherCondition = WeatherUtils.mapConditionToEnum(weatherData.current.condition);
      final rainLevel = WeatherUtils.mapConditionToRainLevel(weatherData.current.condition);

      _state = _state.copyWith(
        currentTemperature: weatherData.current.temperature,
        currentCondition: weatherData.current.condition,
        currentWeather: weatherCondition,
        currentRainLevel: rainLevel,
        hasData: true,
        isLoading: false,
      );

      _updateTimeOfDayFromHour();
      notifyListeners();

    } catch (e) {
      final errorMessage = ErrorHandler.getErrorMessage(e);
      if (!_state.hasData) {
        _setDefaultCurrentWeather();
      }
      _updateState(isLoading: false, error: errorMessage);
    }
  }

  Future<void> _loadWeatherForecast() async {
    try {
      final weatherData = await _weatherService.getWeatherData(_state.currentLocation);

      final hourlyForecasts = weatherData.forecast.hourly.take(12).map((hourly) {
        return Forecast.hourly(
          time: hourly.time,
          icon: WeatherUtils.getIconFromCondition(hourly.condition),
          temperature: WeatherUtils.formatTemperature(hourly.temperature),
          condition: hourly.condition,
        );
      }).toList();

      final dailyForecasts = weatherData.forecast.daily.take(7).map((daily) {
        return Forecast.daily(
          day: WeatherUtils.getDayInSpanish(daily.day),
          icon: WeatherUtils.getIconFromCondition(daily.condition),
          temperature: '${WeatherUtils.formatTemperature(daily.tempMax)} / ${WeatherUtils.formatTemperature(daily.tempMin)}',
          condition: daily.condition,
        );
      }).toList();

      _state = _state.copyWith(
        hourlyForecasts: hourlyForecasts,
        dailyForecasts: dailyForecasts,
      );

      notifyListeners();

    } catch (e) {
      if (_state.hourlyForecasts.isEmpty) {
        _generateFallbackForecastData();
      }
    }
  }

  void _setDefaultCurrentWeather() {
    _state = _state.copyWith(
      currentTemperature: 25.0,
      currentCondition: "despejado",
      currentWeather: model.WeatherCondition.despejado,
      currentRainLevel: RainLevel.ligera,
    );
    _updateTimeOfDayFromHour();
  }

  void _generateFallbackForecastData() {
    final hourlyForecasts = List.generate(6, (index) {
      final hour = (DateTime.now().hour + index + 1) % 24;
      return Forecast.hourly(
        time: '${hour.toString().padLeft(2, '0')}:00',
        icon: Icons.help_outline,
        temperature: '--°',
        condition: 'desconocido',
      );
    });

    final dailyForecasts = List.generate(5, (index) {
      final days = ['Hoy', 'Mañana', 'Mié', 'Jue', 'Vie'];
      return Forecast.daily(
        day: days[index],
        icon: Icons.help_outline,
        temperature: '--° / --°',
        condition: 'desconocido',
      );
    });

    _state = _state.copyWith(
      hourlyForecasts: hourlyForecasts,
      dailyForecasts: dailyForecasts,
    );
    notifyListeners();
  }

  void _updateTimeOfDayFromHour() {
    final hour = DateTime.now().hour;
    model.TimeOfDay timeOfDay;

    if (hour >= 5 && hour < 12) {
      timeOfDay = model.TimeOfDay.manana;
    } else if (hour >= 12 && hour < 18) {
      timeOfDay = model.TimeOfDay.dia;
    } else if (hour >= 18 && hour < 21) {
      timeOfDay = model.TimeOfDay.tarde;
    } else {
      timeOfDay = model.TimeOfDay.noche;
    }

    _state = _state.copyWith(currentTimeOfDay: timeOfDay);
  }

  void _updateState({bool? isLoading, String? error}) {
    _state = _state.copyWith(isLoading: isLoading, error: error);
    notifyListeners();
  }

  // Métodos públicos para interacción
  void setWeatherFromForecast(model.WeatherCondition condition, RainLevel rainLevel) {
    _state = _state.copyWith(
      currentWeather: condition,
      currentRainLevel: rainLevel,
    );
    notifyListeners();
  }

  void cycleTimeOfDay() {
    final values = model.TimeOfDay.values;
    final nextIndex = (_state.currentTimeOfDay.index + 1) % values.length;
    _state = _state.copyWith(
      currentTimeOfDay: values[nextIndex],
      isTimeAccelerated: true,
    );
    notifyListeners();
  }

  void cycleWeatherCondition() {
    final values = model.WeatherCondition.values;
    final nextIndex = (_state.currentWeather.index + 1) % values.length;
    _state = _state.copyWith(currentWeather: values[nextIndex]);
    notifyListeners();
  }

  void cycleRainLevel() {
    if (_state.currentWeather == model.WeatherCondition.lluvioso) {
      final values = RainLevel.values;
      final nextIndex = (_state.currentRainLevel.index + 1) % values.length;
      _state = _state.copyWith(currentRainLevel: values[nextIndex]);
      notifyListeners();
    }
  }

  void changeLocation(String location) {
    if (AppConstants.availableLocations.contains(location) && location != _state.currentLocation) {
      _state = _state.copyWith(
        currentLocation: location,
        isTimeAccelerated: false,
      );
      _loadAllWeatherData();
    }
  }

  void refresh() {
    _state = _state.copyWith(isTimeAccelerated: false);
    _loadAllWeatherData();
  }

  // Getter para el gradiente de fondo
  Gradient get backgroundGradient {
    if (_state.currentWeather == model.WeatherCondition.lluvioso) {
      return ColorPalette.rainyGradient;
    }
    switch (_state.currentTimeOfDay) {
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
}