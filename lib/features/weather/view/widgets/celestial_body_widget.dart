import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../viewmodel/weather_viewmodel.dart';

class CelestialBodyWidget extends StatefulWidget {
  const CelestialBodyWidget({super.key});

  @override
  State<CelestialBodyWidget> createState() => _CelestialBodyWidgetState();
}

class _CelestialBodyWidgetState extends State<CelestialBodyWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  static const Duration _animationDuration = Duration(seconds: 20);
  static const double _sunSize = 80;
  static const double _moonSize = 70;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, viewModel, child) {
        _handleAnimation(viewModel.isTimeAccelerated);

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final progress = _getDayProgress(viewModel.isTimeAccelerated);
            final celestialPositions = _calculateCelestialPositions(progress);

            return Stack(
              children: [
                _buildSun(celestialPositions.sunPosition),
                _buildMoon(celestialPositions.moonPosition),
              ],
            );
          },
        );
      },
    );
  }

  void _handleAnimation(bool isTimeAccelerated) {
    if (isTimeAccelerated && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!isTimeAccelerated && _controller.isAnimating) {
      _controller.stop();
    }
  }

  double _getDayProgress(bool isTimeAccelerated) {
    if (isTimeAccelerated) {
      return _controller.value;
    } else {
      final now = DateTime.now();
      return (now.hour * 3600 + now.minute * 60 + now.second) / (24 * 3600);
    }
  }

  CelestialPositions _calculateCelestialPositions(double dayProgress) {
    final screenSize = MediaQuery.of(context).size;
    final angle = (dayProgress * 2 * math.pi) - (math.pi / 2);
    final orbitRadius = screenSize.width / 1.8;
    final center = Offset(
      screenSize.width / 20,
      screenSize.height,
    );

    return CelestialPositions(
      sunPosition: Offset(
        center.dx + orbitRadius * math.cos(angle),
        center.dy + orbitRadius * math.sin(angle),
      ),
      moonPosition: Offset(
        center.dx + orbitRadius * math.cos(angle + math.pi),
        center.dy + orbitRadius * math.sin(angle + math.pi),
      ),
    );
  }

  Widget _buildSun(Offset position) {
    return Transform.translate(
      offset: position,
      child: Center(
        child: Container(
          width: _sunSize,
          height: _sunSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.yellow.shade600,
            boxShadow: [
              BoxShadow(
                color: Colors.yellow.withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoon(Offset position) {
    return Transform.translate(
      offset: position,
      child: Center(
        child: Container(
          width: _moonSize,
          height: _moonSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Color(0xFFd3d3d3),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
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
    );
  }
}

class CelestialPositions {
  final Offset sunPosition;
  final Offset moonPosition;

  const CelestialPositions({
    required this.sunPosition,
    required this.moonPosition,
  });
}