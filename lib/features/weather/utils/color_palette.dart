import 'package:flutter/material.dart';

class ColorPalette {
  // Paleta Principal (Día Soleado)
  static const Color skyBlue = Color(0xFF47A5F3);
  static const Color lightSkyBlue = Color(0xFF81C7F3);

  // Paleta Nocturna (Noche Despejada)
  static const Color midnightBlue = Color(0xFF0D1117);
  static const Color deepDarkBlue = Color(0xFF212D40);

  // Paleta Lluviosa
  static const Color slateGray = Color(0xFF546E7A);
  static const Color bluishGray = Color(0xFF819CA9);

  // Gradientes
  static const Gradient dayGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [skyBlue, lightSkyBlue],
  );

  static const Gradient nightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [midnightBlue, deepDarkBlue],
  );

  static const Gradient rainyGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [slateGray, bluishGray],
  );

  static const Gradient sunriseGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF8A2387), Color(0xFFE94057), Color(0xFFF27121)],
  );

  static const Gradient sunsetGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF4e54c8), Color(0xFF8f94fb)],
  );
}
