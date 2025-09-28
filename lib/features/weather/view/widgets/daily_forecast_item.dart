import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/daily_forecast_model.dart';
import '../../viewmodel/weather_viewmodel.dart';
import '../../../../core/utils/weather_utils.dart';

class DailyForecastItem extends StatelessWidget {
  final DailyForecast forecast;

  const DailyForecastItem({Key? key, required this.forecast}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final viewModel = context.read<WeatherViewModel>();
        final condition = WeatherUtils.mapConditionToEnum(forecast.condition);
        final rainLevel = WeatherUtils.mapConditionToRainLevel(forecast.condition);

        // Actualizar el clima según el día seleccionado
        viewModel.setWeatherFromForecast(condition, rainLevel);
      },
      child: Container(
        width: 65,
        margin: const EdgeInsets.symmetric(horizontal: 3.0),
        padding: const EdgeInsets.all(3.0),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              forecast.day,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
            Icon(forecast.icon, color: Colors.white, size: 20),
            Text(
              forecast.temperature,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white, fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }
}