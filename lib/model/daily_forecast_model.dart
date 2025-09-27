import 'package:flutter/material.dart';

class DailyForecast {
  final String day;
  final IconData icon;
  final String temperature;
  final String condition;

  DailyForecast({
    required this.day,
    required this.icon,
    required this.temperature,
    required this.condition,
  });
}