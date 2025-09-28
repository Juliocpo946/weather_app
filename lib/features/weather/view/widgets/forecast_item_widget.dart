import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../model/forecast_model.dart';
import '../../viewmodel/weather_viewmodel.dart';
import '../../../../core/utils/weather_utils.dart';

class ForecastItemWidget extends StatelessWidget {
  final Forecast forecast;

  const ForecastItemWidget({
    super.key,
    required this.forecast,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Container(
        width: forecast.isHourly ? 48 : 65,
        margin: forecast.isDaily
            ? const EdgeInsets.symmetric(horizontal: 3.0)
            : null,
        padding: forecast.isHourly
            ? const EdgeInsets.symmetric(horizontal: 3.0, vertical: 4.0)
            : const EdgeInsets.all(3.0),
        decoration: forecast.isDaily
            ? BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.5)),
        )
            : null,
        child: Column(
          mainAxisAlignment: forecast.isHourly
              ? MainAxisAlignment.spaceEvenly
              : MainAxisAlignment.spaceAround,
          children: [
            Text(
              forecast.timeOrDay,
              style: TextStyle(
                color: Colors.white,
                fontWeight: forecast.isDaily ? FontWeight.bold : FontWeight.normal,
                fontSize: forecast.isDaily ? 11 : 10,
              ),
            ),
            Icon(
              forecast.icon,
              color: Colors.white,
              size: forecast.isDaily ? 20 : 18,
            ),
            Text(
              forecast.temperature,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontWeight: forecast.isHourly ? FontWeight.bold : FontWeight.normal,
                fontSize: forecast.isDaily ? 9 : 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTap(BuildContext context) {
    final viewModel = context.read<WeatherViewModel>();
    final condition = WeatherUtils.mapConditionToEnum(forecast.condition);
    final rainLevel = WeatherUtils.mapConditionToRainLevel(forecast.condition);

    viewModel.setWeatherFromForecast(condition, rainLevel);
  }
}