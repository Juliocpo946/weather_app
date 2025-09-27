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
      builder: (context, forecastViewModel, child) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start, // Alineamos el texto
            children: [
              // --- INICIO DEL CAMBIO ---
              // Quitamos el Row y el botón, dejamos solo el título
              const Text(
                'Pronóstico',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // --- FIN DEL CAMBIO ---
              const SizedBox(height: 8),
              if (forecastViewModel.isLoading)
                const SizedBox(
                  height: 120,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              else if (forecastViewModel.error != null)
                SizedBox(
                  height: 120,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error, color: Colors.red, size: 28),
                        const SizedBox(height: 6),
                        Text(
                          forecastViewModel.error!,
                          style: const TextStyle(color: Colors.white, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 6),
                        ElevatedButton(
                          onPressed: () => forecastViewModel.refresh(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white.withOpacity(0.2),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          ),
                          child: const Text('Reintentar', style: TextStyle(fontSize: 11)),
                        ),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    SizedBox(
                      height: 55,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: forecastViewModel.hourlyForecasts.length,
                        itemBuilder: (context, index) {
                          final forecast = forecastViewModel.hourlyForecasts[index];
                          return HourlyForecastItem(forecast: forecast);
                        },
                      ),
                    ),
                    const Divider(color: Colors.white54, height: 8),
                    SizedBox(
                      height: 70,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: forecastViewModel.dailyForecasts.length,
                        itemBuilder: (context, index) {
                          final forecast = forecastViewModel.dailyForecasts[index];
                          return DailyForecastItem(forecast: forecast);
                        },
                      ),
                    ),
                  ],
                ),
            ],
          ),
        );
      },
    );
  }
}