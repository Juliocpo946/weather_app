class WeatherResponse {
  final CurrentWeather current;
  final Forecast forecast;

  WeatherResponse({required this.current, required this.forecast});

  factory WeatherResponse.fromJson(Map<String, dynamic> json) {
    return WeatherResponse(
      current: CurrentWeather.fromJson(json['current']),
      forecast: Forecast.fromJson(json['forecast']),
    );
  }
}

class CurrentWeather {
  final double temperature;
  final String condition;
  final String lastUpdated;

  CurrentWeather({
    required this.temperature,
    required this.condition,
    required this.lastUpdated,
  });

  factory CurrentWeather.fromJson(Map<String, dynamic> json) {
    return CurrentWeather(
      temperature: json['temperature'].toDouble(),
      condition: json['condition'],
      lastUpdated: json['last_updated'],
    );
  }
}

class Forecast {
  final List<HourlyWeather> hourly;
  final List<DailyWeather> daily;

  Forecast({required this.hourly, required this.daily});

  factory Forecast.fromJson(Map<String, dynamic> json) {
    return Forecast(
      hourly: (json['hourly'] as List)
          .map((item) => HourlyWeather.fromJson(item))
          .toList(),
      daily: (json['daily'] as List)
          .map((item) => DailyWeather.fromJson(item))
          .toList(),
    );
  }
}

class HourlyWeather {
  final String time;
  final double temperature;
  final String condition;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.condition,
  });

  factory HourlyWeather.fromJson(Map<String, dynamic> json) {
    return HourlyWeather(
      time: json['time'],
      temperature: json['temperature'].toDouble(),
      condition: json['condition'],
    );
  }
}

class DailyWeather {
  final String day;
  final double tempMax;
  final double tempMin;
  final String condition;

  DailyWeather({
    required this.day,
    required this.tempMax,
    required this.tempMin,
    required this.condition,
  });

  factory DailyWeather.fromJson(Map<String, dynamic> json) {
    return DailyWeather(
      day: json['day'],
      tempMax: json['temp_max'].toDouble(),
      tempMin: json['temp_min'].toDouble(),
      condition: json['condition'],
    );
  }
}