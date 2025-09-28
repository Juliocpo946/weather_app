import 'weather_model.dart' as weather_model;
import 'rain_level_model.dart';
import 'daily_forecast_model.dart';
import 'hourly_forecast_model.dart';

class WeatherState {
  final weather_model.TimeOfDay currentTimeOfDay;
  final weather_model.WeatherCondition currentWeather;
  final RainLevel currentRainLevel;
  final double currentTemperature;
  final String currentCondition;
  final String currentLocation;
  final bool isLoading;
  final String? error;
  final bool hasData;
  final bool isTimeAccelerated;
  final List<HourlyForecast> hourlyForecasts;
  final List<DailyForecast> dailyForecasts;

  const WeatherState({
    required this.currentTimeOfDay,
    required this.currentWeather,
    required this.currentRainLevel,
    required this.currentTemperature,
    required this.currentCondition,
    required this.currentLocation,
    required this.isLoading,
    this.error,
    required this.hasData,
    required this.isTimeAccelerated,
    required this.hourlyForecasts,
    required this.dailyForecasts,
  });

  WeatherState copyWith({
    weather_model.TimeOfDay? currentTimeOfDay,
    weather_model.WeatherCondition? currentWeather,
    RainLevel? currentRainLevel,
    double? currentTemperature,
    String? currentCondition,
    String? currentLocation,
    bool? isLoading,
    String? error,
    bool? hasData,
    bool? isTimeAccelerated,
    List<HourlyForecast>? hourlyForecasts,
    List<DailyForecast>? dailyForecasts,
  }) {
    return WeatherState(
      currentTimeOfDay: currentTimeOfDay ?? this.currentTimeOfDay,
      currentWeather: currentWeather ?? this.currentWeather,
      currentRainLevel: currentRainLevel ?? this.currentRainLevel,
      currentTemperature: currentTemperature ?? this.currentTemperature,
      currentCondition: currentCondition ?? this.currentCondition,
      currentLocation: currentLocation ?? this.currentLocation,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      hasData: hasData ?? this.hasData,
      isTimeAccelerated: isTimeAccelerated ?? this.isTimeAccelerated,
      hourlyForecasts: hourlyForecasts ?? this.hourlyForecasts,
      dailyForecasts: dailyForecasts ?? this.dailyForecasts,
    );
  }

  factory WeatherState.initial() {
    return WeatherState(
      currentTimeOfDay: weather_model.TimeOfDay.dia,
      currentWeather: weather_model.WeatherCondition.despejado,
      currentRainLevel: RainLevel.ligera,
      currentTemperature: 25.0,
      currentCondition: "despejado",
      currentLocation: 'suchiapa',
      isLoading: false,
      hasData: false,
      isTimeAccelerated: false,
      hourlyForecasts: const [],
      dailyForecasts: const [],
    );
  }
}