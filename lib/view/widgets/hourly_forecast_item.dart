import 'package:flutter/material.dart';
import '../../model/hourly_forecast_model.dart';

class HourlyForecastItem extends StatelessWidget {
  final HourlyForecast forecast;

  const HourlyForecastItem({Key? key, required this.forecast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 55,
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(forecast.time,
              style: const TextStyle(color: Colors.white, fontSize: 11)),
          Icon(forecast.icon, color: Colors.white, size: 22),
          Text(forecast.temperature,
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 11)),
        ],
      ),
    );
  }
}

