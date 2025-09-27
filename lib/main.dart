import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'view/weather_screen.dart';
import 'viewmodel/weather_forecast_viewmodel.dart';
import 'viewmodel/weather_viewmodel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Usamos MultiProvider para proveer ambos ViewModels a la app.
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
        ChangeNotifierProvider(create: (_) => WeatherForecastViewModel()),
      ],
      child: const MaterialApp(
        home: WeatherScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

