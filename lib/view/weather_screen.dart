import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/weather_model.dart';
import '../viewmodel/weather_viewmodel.dart';
import 'widgets/current_status_widget.dart';
import 'widgets/rain_widget.dart';
import 'widgets/stars_widget.dart';
import 'widgets/weather_forecast_widget.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WeatherViewModel>();

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Fondo animado y capas de opacidad
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(gradient: viewModel.backgroundGradient),
          ),
          AnimatedContainer(
            duration: const Duration(seconds: 2),
            curve: Curves.easeInOut,
            color: Colors.black.withOpacity(1 - viewModel.backgroundOpacity),
          ),

          // Efectos climáticos (Estrellas y Lluvia)
          AnimatedOpacity(
            duration: const Duration(seconds: 2),
            opacity: viewModel.showStars ? 1.0 : 0.0,
            child: const StarsWidget(numberOfStars: 150),
          ),
          AnimatedOpacity(
            duration: const Duration(seconds: 1),
            opacity:
            viewModel.currentWeather == WeatherCondition.lluvioso ? 1.0 : 0.0,
            child: RainWidget(level: viewModel.currentRainLevel),
          ),

          // Contenedor principal para los widgets de información
          Positioned(
            bottom: 40,
            left: 30,
            right: 100,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                // Nuevo widget de estado actual
                CurrentStatusWidget(),
                SizedBox(height: 15),
                // Widget de pronóstico
                WeatherForecastWidget(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _buildControlButtons(context),
    );
  }

  Widget _buildControlButtons(BuildContext context) {
    final viewModel = context.read<WeatherViewModel>();
    final weatherState = context.watch<WeatherViewModel>();

    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: viewModel.cycleTimeOfDay,
                tooltip: 'Cambiar Hora',
                heroTag: 'time',
                child: const Icon(Icons.access_time),
              ),
              const SizedBox(height: 10),
              FloatingActionButton(
                onPressed: viewModel.cycleWeatherCondition,
                tooltip: 'Cambiar Clima',
                heroTag: 'weather',
                child: const Icon(Icons.cloud_outlined),
              ),
              const SizedBox(height: 10),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: weatherState.currentWeather == WeatherCondition.lluvioso
                    ? 1.0
                    : 0.0,
                child: weatherState.currentWeather == WeatherCondition.lluvioso
                    ? FloatingActionButton(
                  onPressed: viewModel.cycleRainLevel,
                  tooltip: 'Cambiar Intensidad',
                  heroTag: 'rain',
                  child: const Icon(Icons.water_drop_outlined),
                )
                    : const SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

