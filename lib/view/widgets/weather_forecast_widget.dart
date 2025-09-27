import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/weather_forecast_viewmodel.dart';
import 'daily_forecast_item.dart';
import 'hourly_forecast_item.dart';

class WeatherForecastWidget extends StatelessWidget {
  const WeatherForecastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherForecastViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.1),
          ),
          child: viewModel.isLoading
              ? const SizedBox(
            height: 160, // Altura ajustada durante la carga
            child: Center(
                child: CircularProgressIndicator(color: Colors.white)),
          )
              : Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // --- Carrusel de Pronóstico por Hora ---
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.hourlyForecasts.length,
                  itemBuilder: (context, index) {
                    final forecast = viewModel.hourlyForecasts[index];
                    return HourlyForecastItem(forecast: forecast);
                  },
                ),
              ),
              const Divider(color: Colors.white54, height: 8),
              // --- Carrusel de Pronóstico por Días ---
              SizedBox(
                height: 85,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: viewModel.dailyForecasts.length,
                  itemBuilder: (context, index) {
                    final forecast = viewModel.dailyForecasts[index];
                    return DailyForecastItem(forecast: forecast);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

