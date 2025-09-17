import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroWidget extends StatelessWidget {
  const HeroWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String heroText = "WELCOME TO WEATHER APP\nLogin to Continue!";

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              
              Text(
                heroText,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..style = PaintingStyle.stroke
                    ..strokeWidth = 4
                    ..color = Colors.white,
                ),
              ),
              
              Text(
                heroText,
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 72,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  shadows: [
                    Shadow(
                      blurRadius: 16,
                      color: Colors.white.withOpacity(0.8),
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
