import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

class IntroPage2 extends StatelessWidget {
  const IntroPage2({Key? key}) : super(key: key);

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
                padding: const EdgeInsets.only(
                    top: 70.0, right: 8), // Adjust this value
                child: Column(
                  children: [
                    Lottie.network(
                      'https://lottie.host/62a96765-8b8e-4b66-a122-38fd68ca3b8f/A3AENSU6co.json',
                      width: 430,
                      height: 430,
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
                          'You can view records of sports and step counting activities.',
                          style: GoogleFonts.anekGurmukhi(
                            fontSize: 22,
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
