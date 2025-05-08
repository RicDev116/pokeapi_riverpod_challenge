import 'package:flutter/material.dart';

Color getTextColorForBackground(Color backgroundColor) {
  // Calcula el brillo del color para decidir si el texto debe ser blanco o negro
  final brightness = backgroundColor.computeLuminance();
  return brightness < 0.5 ? Colors.white : Colors.black;
}
