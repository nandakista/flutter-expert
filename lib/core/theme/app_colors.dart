import 'package:flutter/material.dart';

class AppColors {
  // General
  static const Color primary = Color(0xffffba00);
  static const Color primaryVariant = Color(0xffffde8b);
  static const Color onPrimary = Color(0xfffba81a);
  static const Color secondary = Color(0xffcf0a10);
  static const Color secondaryVariant = Color(0xffd02a2f);
  static const Color accent = Color(0xff8f9bb3);

  // Material Color
  static Map<int, Color> color = {
    50: const Color.fromRGBO(255, 255, 255, 1.0),
    100: const Color.fromRGBO(255, 255, 255, 0.9294117647058824),
    200: const Color.fromRGBO(255, 255, 255, 1.0),
    300: const Color.fromRGBO(213, 209, 211, 1.0),
    400: const Color.fromRGBO(199, 198, 199, 1.0),
    500: const Color.fromRGBO(179, 175, 177, 1.0),
    600: const Color.fromRGBO(156, 155, 156, 1.0),
    700: const Color.fromRGBO(139, 136, 137, 1.0),
    800: const Color.fromRGBO(68, 68, 68, 1.0),
    900: const Color.fromRGBO(45, 45, 45, 1.0),
  };
  static MaterialColor materialPrimary = MaterialColor(0xffffba00, color);
}