import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/weather_model.dart';
import '../viewmodel/weather_viewmodel.dart';
import '../viewmodel/weather_forecast_viewmodel.dart';
import 'widgets/current_status_widget.dart';
import 'widgets/location_selector_widget.dart'; // Importamos el nuevo widget
import 'widgets/rain_widget.dart';
import 'widgets/stars_widget.dart';
import 'widgets/weather_forecast_widget.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Consumer<WeatherViewModel>(
        builder: (context, viewModel, child) {
          return Stack(
            children: [
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
              AnimatedOpacity(
                duration: const Duration(seconds: 2),
                opacity: viewModel.showStars ? 1.0 : 0.0,
                child: const StarsWidget(numberOfStars: 150),
              ),
              AnimatedOpacity(
                duration: const Duration(seconds: 1),
                opacity: viewModel.currentWeather == WeatherCondition.lluvioso ? 1.0 : 0.0,
                child: RainWidget(level: viewModel.currentRainLevel),
              ),
              Positioned(
                bottom: 40,
                left: 30,
                right: 100,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start, // Alineamos al inicio
                  children: [
                    // --- INICIO DEL CAMBIO ---
                    // Usamos una fila para alinear el estatus y el selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Para separarlos
                      crossAxisAlignment: CrossAxisAlignment.start, // Alineación vertical
                      children: [
                        const CurrentStatusWidget(), // Widget de la fecha y hora
                        const LocationSelectorWidget(), // Nuevo widget del selector
                      ],
                    ),
                    // --- FIN DEL CAMBIO ---
                    const SizedBox(height: 15),
                    const WeatherForecastWidget(),
                    if (viewModel.error != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.error, color: Colors.white),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                viewModel.error!,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.refresh, color: Colors.white),
                              onPressed: () => viewModel.refresh(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );
        },
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: FloatingActionButton(
                  onPressed: viewModel.cycleTimeOfDay,
                  tooltip: 'Cambiar Hora',
                  heroTag: 'time',
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: const Icon(Icons.access_time, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: FloatingActionButton(
                  onPressed: viewModel.cycleWeatherCondition,
                  tooltip: 'Cambiar Clima',
                  heroTag: 'weather',
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: const Icon(Icons.cloud_outlined, color: Colors.white),
                ),
              ),
              const SizedBox(height: 10),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 500),
                opacity: weatherState.currentWeather == WeatherCondition.lluvioso ? 1.0 : 0.0,
                child: weatherState.currentWeather == WeatherCondition.lluvioso
                    ? Container(
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: FloatingActionButton(
                    onPressed: viewModel.cycleRainLevel,
                    tooltip: 'Cambiar Intensidad',
                    heroTag: 'rain',
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    child: const Icon(Icons.water_drop_outlined, color: Colors.white),
                  ),
                )
                    : const SizedBox(),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: FloatingActionButton(
                  onPressed: () {
                    viewModel.refresh();
                    context.read<WeatherForecastViewModel>().refresh();
                  },
                  tooltip: 'Actualizar',
                  heroTag: 'refresh',
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  child: const Icon(Icons.refresh, color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}