import 'package:flutter/material.dart';

class MountainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E5631) // Un verde más oscuro
      ..style = PaintingStyle.fill;

    // Lista de montañas con diferentes tamaños y posiciones
    final mountains = [
      {'x': 0.5, 'y': 0.3, 'width': 0.6},
      {'x': 0.2, 'y': 0.5, 'width': 0.4},
      {'x': 0.8, 'y': 0.4, 'width': 0.5},
      {'x': 0.0, 'y': 0.6, 'width': 0.3},
      {'x': 1.0, 'y': 0.5, 'width': 0.4},
    ];

    for (var mountain in mountains) {
      final path = Path();
      path.moveTo(size.width * mountain['x']!, size.height * mountain['y']!);
      path.lineTo(size.width * (mountain['x']! - mountain['width']! / 2), size.height);
      path.lineTo(size.width * (mountain['x']! + mountain['width']! / 2), size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}