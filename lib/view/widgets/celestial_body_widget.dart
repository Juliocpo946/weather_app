import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../viewmodel/weather_viewmodel.dart';

class CelestialBodyWidget extends StatefulWidget {
  // Corregido: Uso de super parameters para 'key'
  const CelestialBodyWidget({super.key});

  @override
  // Corregido: El nombre de la clase de estado ahora es público
  CelestialBodyWidgetState createState() => CelestialBodyWidgetState();
}

// Corregido: La clase de estado ahora es pública
class CelestialBodyWidgetState extends State<CelestialBodyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20), // Duración del ciclo acelerado
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<WeatherViewModel>();

    if (viewModel.isTimeAccelerated) {
      if (!_controller.isAnimating) {
        _controller.repeat();
      }
    } else {
      if (_controller.isAnimating) {
        _controller.stop();
      }
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        double dayProgress;

        if (viewModel.isTimeAccelerated) {
          dayProgress = _controller.value;
        } else {
          final now = DateTime.now();
          dayProgress = (now.hour * 3600 + now.minute * 60 + now.second) / (24 * 3600);
        }

        final angle = (dayProgress * 2 * math.pi) - (math.pi / 2);
        final orbitRadius = MediaQuery.of(context).size.width / 1.8;
        final center = Offset(
          MediaQuery.of(context).size.width / 20,
          MediaQuery.of(context).size.height * 1,
        );

        return Stack(
          children: [
            // --- Sol ---
            Transform.translate(
              offset: Offset(
                center.dx + orbitRadius * math.cos(angle),
                center.dy + orbitRadius * math.sin(angle),
              ),
              child: Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow.shade600,
                  ),
                ),
              ),
            ),
            // --- Luna ---
            Transform.translate(
              // Corregido: Se eliminó la resta del centro
              offset: Offset(
                center.dx + orbitRadius * math.cos(angle + math.pi),
                center.dy + orbitRadius * math.sin(angle + math.pi),
              ),
              child: Center(
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFd3d3d3),
                  ),
                  child: ClipOval(
                    child: Transform.translate(
                      offset: const Offset(-15, 0),
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: const Color(0xFF0D1117).withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}