import 'package:flutter/material.dart';
import '../../model/weather_model.dart';
import '../../model/rain_level_model.dart';

class WeatherUtils {
  static WeatherCondition mapConditionToEnum(String condition) {
    if (condition.contains('lluvia') || condition.contains('chubascos') || condition.contains('tormenta')) {
      return WeatherCondition.lluvioso;
    } else if (condition.contains('nublado') || condition.contains('neblina') || condition.contains('niebla')) {
      return WeatherCondition.nublado;
    } else {
      return WeatherCondition.despejado;
    }
  }

  static RainLevel mapConditionToRainLevel(String condition) {
    if (condition.contains('lluvia ligera')) return RainLevel.ligera;
    if (condition.contains('lluvia moderada')) return RainLevel.moderada;
    if (condition.contains('chubascos')) return RainLevel.fuerte;
    if (condition.contains('tormenta')) return RainLevel.torrencial;
    return RainLevel.ligera;
  }

  static String getEmojiFromCondition(String condition, {bool isNight = false}) {
    if (condition.contains('tormenta')) return '⛈️';
    if (condition.contains('lluvia') || condition.contains('chubascos')) return '🌧️';
    if (condition.contains('nublado')) return '☁️';
    if (condition.contains('neblina') || condition.contains('niebla')) return '🌫️';
    if (condition.contains('despejado')) return isNight ? '🌙' : '☀️';
    return isNight ? '🌙' : '☀️';
  }

  static IconData getIconFromCondition(String condition) {
    if (condition.contains('tormenta')) return Icons.thunderstorm;
    if (condition.contains('lluvia') || condition.contains('chubascos')) return Icons.grain;
    if (condition.contains('nublado')) return Icons.cloud;
    if (condition.contains('neblina') || condition.contains('niebla')) return Icons.cloud_queue;
    return Icons.wb_sunny;
  }

  static bool isNightTime() {
    final hour = DateTime.now().hour;
    return (hour >= 19) || (hour < 6);
  }

  static String formatTemperature(double temp) {
    return '${temp.round()}°C';
  }

  static String getDayInSpanish(String englishDay) {
    final daysMap = {
      'Monday': 'Lun',
      'Tuesday': 'Mar',
      'Wednesday': 'Mié',
      'Thursday': 'Jue',
      'Friday': 'Vie',
      'Saturday': 'Sáb',
      'Sunday': 'Dom',
      'Hoy': 'Hoy',
      'Mañana': 'Mañana',
    };
    return daysMap[englishDay] ?? englishDay;
  }

  static WeatherCondition getConditionFromTime(String time) {
    final hour = int.tryParse(time.split(':')[0]) ?? 12;
    if (hour >= 14 && hour <= 18) {
      return WeatherCondition.nublado; // Tarde nublada
    } else if (hour >= 20 || hour <= 4) {
      return WeatherCondition.lluvioso; // Noche lluviosa ocasional
    }
    return WeatherCondition.despejado;
  }
}