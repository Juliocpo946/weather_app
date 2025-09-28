import 'weather_model.dart' as weather_model;
import 'rain_level_model.dart';
import 'forecast_model.dart';

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
  final List<Forecast> hourlyForecasts;
  final List<Forecast> dailyForecasts;

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
    List<Forecast>? hourlyForecasts,
    List<Forecast>? dailyForecasts,
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
      hourlyForecasts: const [],
      dailyForecasts: const [],
    );
  }

  String get formattedTemperature => '${currentTemperature.round()}°C';

  String get currentEmoji {
    final isNight = _isNightTime();
    if (currentCondition.contains('tormenta')) return '⛈️';
    if (currentCondition.contains('lluvia') || currentCondition.contains('chubascos')) return '🌧️';
    if (currentCondition.contains('nublado')) return '☁️';
    if (currentCondition.contains('neblina') || currentCondition.contains('niebla')) return '🌫️';
    if (currentCondition.contains('despejado')) return isNight ? '🌙' : '☀️';
    return isNight ? '🌙' : '☀️';
  }

  bool get showStars {
    return currentTimeOfDay == weather_model.TimeOfDay.noche &&
        currentWeather == weather_model.WeatherCondition.despejado;
  }

  double get backgroundOpacity {
    if (currentWeather == weather_model.WeatherCondition.nublado) return 0.7;
    if (currentWeather == weather_model.WeatherCondition.lluvioso) return 0.5;
    return 1.0;
  }

  bool _isNightTime() {
    final hour = DateTime.now().hour;
    return (hour >= 19) || (hour < 6);
  }
}