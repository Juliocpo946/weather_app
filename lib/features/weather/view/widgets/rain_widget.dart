import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../../model/rain_level_model.dart';
import '../../utils/range_map.dart';

class RainWidget extends StatefulWidget {
  final RainLevel level;
  const RainWidget({super.key, required this.level});

  @override
  State<RainWidget> createState() => _RainWidgetState();
}

class _RainWidgetState extends State<RainWidget> {
  List<_RainDrop> rainDrops = [];
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _buildRainDrops();
      _isInitialized = true;
    }
  }

  @override
  void didUpdateWidget(covariant RainWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.level != widget.level) {
      _buildRainDrops();
    }
  }

  void _buildRainDrops() {
    final screenSize = MediaQuery.sizeOf(context);
    setState(() {
      rainDrops = List.generate(
        widget.level.count,
            (index) => _RainDrop(
          screenHeight: screenSize.height,
          screenWidth: screenSize.width,
          level: widget.level,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: rainDrops);
  }
}

class _RainDrop extends StatefulWidget {
  final double screenHeight, screenWidth;
  final RainLevel level;

  const _RainDrop({
    required this.screenHeight,
    required this.screenWidth,
    required this.level,
  });

  @override
  State<_RainDrop> createState() => _RainDropState();
}

class _RainDropState extends State<_RainDrop> with SingleTickerProviderStateMixin {
  late double dx, dy, length, z, vy, width;
  final Random random = Random();
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _randomizeValues();
    _ticker = createTicker((elapsed) {
      setState(() {
        dy += vy;
        if (dy >= widget.screenHeight + 100) {
          _randomizeValues();
        }
      });
    });
    _ticker.start();
  }

  void _randomizeValues() {
    final level = widget.level;
    dx = random.nextDouble() * widget.screenWidth;
    dy = -500 - (random.nextDouble() * -500);
    z = random.nextDouble() * 20;

    length = rangeMap(z, 0, 20, level.farLength, level.nearLength);
    vy = rangeMap(z, 0, 20, level.farSpeed, level.nearSpeed);
    width = rangeMap(z, 0, 20, level.farWidth, level.nearWidth);
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(dx, dy),
      child: Container(
        height: length,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.white,
        ),
      ),
    );
  }
}

