import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/weather_viewmodel.dart';

class CurrentStatusWidget extends StatefulWidget {
  const CurrentStatusWidget({Key? key}) : super(key: key);

  @override
  State<CurrentStatusWidget> createState() => _CurrentStatusWidgetState();
}

class _CurrentStatusWidgetState extends State<CurrentStatusWidget> {
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Actualizamos la hora cada segundo para mantenerla al día.
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  // Formateador simple para la fecha en español.
  String _formatDate(DateTime date) {
    const days = ['Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo'];
    const months = ['Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio', 'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'];
    return '${days[date.weekday - 1]}, ${date.day} de ${months[date.month - 1]}';
  }

  // Formateador simple para la hora.
  String _formatTime(DateTime date) {
    final hour = date.hour > 12 ? date.hour - 12 : date.hour == 0 ? 12 : date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final period = date.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WeatherViewModel>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // --- COLUMNA IZQUIERDA: EMOJI ---
        Text(
          viewModel.currentEmoji,
          style: const TextStyle(fontSize: 40),
        ),
        const SizedBox(width: 10),

        // --- COLUMNA DERECHA: INFORMACIÓN ---
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Temperatura
            Text(
              viewModel.currentTemperature,
              style: const TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 3, color: Colors.black87)],
              ),
            ),
            // Condición del clima (ej: "Despejado")
            Text(
              '${viewModel.currentWeather.name[0].toUpperCase()}${viewModel.currentWeather.name.substring(1)}',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 2, color: Colors.black54)],
              ),
            ),
            const SizedBox(height: 6),
            // Hora actual
            Text(
              _formatTime(_now),
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white,
                shadows: [Shadow(blurRadius: 2, color: Colors.black54)],
              ),
            ),
            // Fecha actual
            Text(
              _formatDate(_now),
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
                shadows: [Shadow(blurRadius: 2, color: Colors.black54)],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

