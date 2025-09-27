import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../viewmodel/weather_forecast_viewmodel.dart';
import '../../viewmodel/weather_viewmodel.dart';

class LocationSelectorWidget extends StatelessWidget {
  const LocationSelectorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Escuchamos a ambos ViewModels para obtener y actualizar datos
    final weatherViewModel = context.watch<WeatherViewModel>();
    final forecastViewModel = context.read<WeatherForecastViewModel>();

    return DropdownButton<String>(
      value: weatherViewModel.currentLocation,
      dropdownColor: Colors.black87,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      underline: Container(), // Sin línea debajo
      items: AppConstants.availableLocations.map((location) {
        return DropdownMenuItem(
          value: location,
          child: Text(
            AppConstants.locationNames[location] ?? location,
          ),
        );
      }).toList(),
      onChanged: (newLocation) {
        if (newLocation != null) {
          // Actualizamos la ubicación en ambos ViewModels
          context.read<WeatherViewModel>().changeLocation(newLocation);
          forecastViewModel.changeLocation(newLocation);
        }
      },
    );
  }
}