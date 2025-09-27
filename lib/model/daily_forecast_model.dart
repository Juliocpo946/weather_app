import 'package:flutter/material.dart';

class DailyForecast {
  final String day;
  final IconData icon;
  final String temperature;

  DailyForecast({
    required this.day,
    required this.icon,
    required this.temperature,
  });
}
