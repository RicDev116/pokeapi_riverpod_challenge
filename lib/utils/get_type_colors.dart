import 'dart:ui';

import 'package:flutter/material.dart';

Color getTypeColor(String type) {
  switch (type.toLowerCase()) {
    case 'fire':
      return Colors.redAccent;
    case 'water':
      return Colors.blueAccent;
    case 'grass':
      return Colors.green;
    case 'electric':
      return Colors.yellow.shade600;
    case 'psychic':
      return Colors.purpleAccent;
    case 'bug':
      return Colors.lightGreen;
    default:
      return Colors.grey.shade800;
  }
}
