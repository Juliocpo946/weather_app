import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/weather_viewmodel.dart';
import 'forecast_item_widget.dart';

class WeatherForecastWidget extends StatelessWidget {
  const WeatherForecastWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, viewModel, child) {
        return Container(
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white.withOpacity(0.8), width: 1),
            borderRadius: BorderRadius.circular(15),
            color: Colors.black.withOpacity(0.1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Pronóstico',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              if (viewModel.isLoading)
                const SizedBox(
                  height: 120,
                  child: Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                )
              else if (viewModel.error != null && !viewModel.hasData)
                _buildErrorWidget(viewModel)
              else
                _buildForecastContent(viewModel),
            ],
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget(WeatherViewModel viewModel) {
    return SizedBox(
      height: 120,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 28),
            const SizedBox(height: 6),
            Text(
              viewModel.error!,
              style: const TextStyle(color: Colors.white, fontSize: 12),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            ElevatedButton(
              onPressed: () => viewModel.refresh(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.2),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
              child: const Text('Reintentar', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildForecastContent(WeatherViewModel viewModel) {
    return Column(
      children: [
        SizedBox(
          height: 55,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.hourlyForecasts.length,
            itemBuilder: (context, index) {
              return ForecastItemWidget(forecast: viewModel.hourlyForecasts[index]);
            },
          ),
        ),
        const Divider(color: Colors.white54, height: 8),
        SizedBox(
          height: 70,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: viewModel.dailyForecasts.length,
            itemBuilder: (context, index) {
              return ForecastItemWidget(forecast: viewModel.dailyForecasts[index]);
            },
          ),
        ),
      ],
    );
  }
}