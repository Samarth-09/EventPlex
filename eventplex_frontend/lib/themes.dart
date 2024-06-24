import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class Themes {
  static Color red = const Color.fromARGB(255, 250, 37, 40);
  static Color grey = const Color.fromARGB(255, 240, 240, 240);
  static Color lightred = const Color.fromARGB(255, 250, 212, 213);
  static Color black = Colors.black;
  static Color white = Colors.white;
  static Color transparent = const Color.fromARGB(0, 255, 255, 255);
  static TextStyle textStyle(
      {required double fontsize, required Color fontColor, FontWeight? fw}) {
    return GoogleFonts.getFont("Raleway")
        .copyWith(color: fontColor, fontSize: fontsize, fontWeight: fw);
  }
}
