import 'package:flutter/material.dart';
import '../../model/daily_forecast_model.dart';

class DailyForecastItem extends StatelessWidget {
  final DailyForecast forecast;

  const DailyForecastItem({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Contenedor con ancho y tamaño de fuente reducidos
    return Container(
      width: 80,
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      padding: const EdgeInsets.all(4.0),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.7)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            forecast.day,
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Icon(forecast.icon, color: Colors.white, size: 25),
          Text(
            forecast.temperature,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 11),
          ),
        ],
      ),
    );
  }
}

