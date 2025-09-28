import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/hourly_forecast_model.dart';
import '../../viewmodel/weather_viewmodel.dart';
import '../../../../core/utils/weather_utils.dart';

class HourlyForecastItem extends StatelessWidget {
  final HourlyForecast forecast;

  const HourlyForecastItem({Key? key, required this.forecast})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final viewModel = context.read<WeatherViewModel>();
        final condition = WeatherUtils.mapConditionToEnum(forecast.condition);
        final rainLevel = WeatherUtils.mapConditionToRainLevel(forecast.condition);

        // Actualizar el clima según la hora seleccionada
        viewModel.setWeatherFromForecast(condition, rainLevel);
      },
      child: Container(
        width: 48,
        padding: const EdgeInsets.symmetric(horizontal: 3.0, vertical: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              forecast.time,
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
            Icon(forecast.icon, color: Colors.white, size: 18),
            Text(
              forecast.temperature,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}