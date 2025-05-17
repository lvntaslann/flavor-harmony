import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({Key? key}) : super(key: key);

  @override
  _IntroPage1State createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
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
                padding: const EdgeInsets.only(top: 50.0), // Adjust this value
                child: Column(
                  children: [
                    Lottie.network(
                      'https://lottie.host/872facad-5020-4e9e-b20c-4d162a33eb99/eQUb2G4XJy.json',
                      width: 450,
                      height: 450,
                      fit: BoxFit.cover,
                    ),
                    Padding(padding: const EdgeInsets.only(top: 50)),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20), // Kenarlara padding ekleyin
                      width: 380,
                      height: 130,
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 67, 67, 67),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        // Metni merkeze almak için Center widget'ını kullanın
                        child: Text(
                          'Record what you eat and streamline tasks with an additional object recognition feature.',
                          style: GoogleFonts.anekGurmukhi(
                            fontSize: 21,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign:
                              TextAlign.center, // Metni merkeze hizalayın
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
