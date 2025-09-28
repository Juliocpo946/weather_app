import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_constants.dart';
import '../../viewmodel/weather_viewmodel.dart';

class LocationSelectorWidget extends StatelessWidget {
  const LocationSelectorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherViewModel = context.watch<WeatherViewModel>();

    return DropdownButton<String>(
      value: weatherViewModel.currentLocation,
      dropdownColor: Colors.black87,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
      underline: Container(),
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
          weatherViewModel.changeLocation(newLocation);
        }
      },
    );
  }
}