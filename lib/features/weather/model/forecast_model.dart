import 'package:flutter/material.dart';

enum ForecastType { hourly, daily }

class Forecast {
  final String timeOrDay;
  final IconData icon;
  final String temperature;
  final String condition;
  final ForecastType type;

  const Forecast({
    required this.timeOrDay,
    required this.icon,
    required this.temperature,
    required this.condition,
    required this.type,
  });

  factory Forecast.hourly({
    required String time,
    required IconData icon,
    required String temperature,
    required String condition,
  }) {
    return Forecast(
      timeOrDay: time,
      icon: icon,
      temperature: temperature,
      condition: condition,
      type: ForecastType.hourly,
    );
  }

  factory Forecast.daily({
    required String day,
    required IconData icon,
    required String temperature,
    required String condition,
  }) {
    return Forecast(
      timeOrDay: day,
      icon: icon,
      temperature: temperature,
      condition: condition,
      type: ForecastType.daily,
    );
  }

  bool get isHourly => type == ForecastType.hourly;
  bool get isDaily => type == ForecastType.daily;
}