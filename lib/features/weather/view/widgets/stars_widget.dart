import 'dart:math';
import 'package:flutter/material.dart';

class StarsWidget extends StatefulWidget {
  final int numberOfStars;
  const StarsWidget({Key? key, this.numberOfStars = 150}) : super(key: key);

  @override
  State<StarsWidget> createState() => _StarsWidgetState();
}

class _StarsWidgetState extends State<StarsWidget> {
  late List<_Star> stars;

  @override
  void initState() {
    super.initState();
    stars = List.generate(widget.numberOfStars, (index) => _Star.random());
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Stack(
        children: stars.map((star) {
          return Positioned(
            left: star.x * constraints.maxWidth,
            top: star.y * constraints.maxHeight,
            child: Container(
              width: star.size,
              height: star.size,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

class _Star {
  final double x;
  final double y;
  final double size;

  _Star({required this.x, required this.y, required this.size});

  factory _Star.random() {
    final random = Random();
    return _Star(
      x: random.nextDouble(),
      y: random.nextDouble(),
      size: random.nextDouble() * 1.5 + 0.5,
    );
  }
}
