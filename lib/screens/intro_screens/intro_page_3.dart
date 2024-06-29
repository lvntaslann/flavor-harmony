import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      body: Stack(
        children: [
          Positioned.fill(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 70.0),
                child: Column(
                  children: [
                    Lottie.network(
                      'https://lottie.host/cd8e76fc-5a63-4f25-87bc-ec5e476b964b/o3sdsfdOAy.json',
                      width: 430,
                      height: 430,
                      fit: BoxFit.cover,
                    ),
                    Padding(padding: const EdgeInsets.only(top: 50)),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: 380,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 67, 67, 67),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'You can track water intake with Flavor Harmony!',
                          style: GoogleFonts.anekGurmukhi(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
