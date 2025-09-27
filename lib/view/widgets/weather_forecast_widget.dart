import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../viewmodel/weather_forecast_viewmodel.dart';
import '../../viewmodel/weather_viewmodel.dart';
import 'daily_forecast_item.dart';
import 'hourly_forecast_item.dart';

class WeatherForecastWidget extends StatelessWidget {
  const WeatherForecastWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer2<WeatherForecastViewModel, WeatherViewModel>(
      builder: (context, forecastViewModel, weatherViewModel, child) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Pronóstico',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.white.withOpacity(0.5)),
                    ),
                    child: DropdownButton<String>(
                      value: weatherViewModel.currentLocation,
                      dropdownColor: Colors.black87,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      underline: Container(),
                      items: AppConstants.availableLocations.map((location) {
                        return DropdownMenuItem(
                          value: location,
                          child: Text(
                            AppConstants.locationNames[location] ?? location,
                            style: const TextStyle(fontSize: 12),
                          ),
                        );
                      }).toList(),
                      onChanged: (newLocation) {
                        if (newLocation != null) {
                          weatherViewModel.changeLocation(newLocation);
                          forecastViewModel.changeLocation(newLocation);
                        }
                      },
                    ),
                  ),
                ],
              ),
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