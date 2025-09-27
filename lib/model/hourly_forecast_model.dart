import 'package:flutter/material.dart';

class HourlyForecast {
  final String time;
  final IconData icon;
  final String temperature;

  HourlyForecast({
    required this.time,
    required this.icon,
    required this.temperature,
  });
}
