import 'package:flavor_harmony_app/BMI-calculator/height_weight_screen.dart';
import 'package:flavor_harmony_app/BMI-calculator/next_text_button.dart';
import 'package:flutter/material.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({super.key});

  @override
  State<AgeScreen> createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  TextEditingController ageController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      appBar: AppBar(
        title: const Text(
          'BMI Calculator',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromARGB(255, 31, 31, 31),
        iconTheme: IconThemeData(
          color: Colors.white, // Geri dönüş okunun rengini beyaz yapar
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextContainer(
              size: size,
              text: 'I am',
              lottieAnimationLink:
                  'https://lottie.host/976cbc78-21f8-4592-98a2-fff68cf64f30/nTwSdEi46y.json',
            ),
            SizedBox(height: size.height * 0.15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width * 0.3,
                  height: size.height * 0.1,
                  child: TextField(
                    controller: ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 31, 31, 31)
                                .withOpacity(0.5)),
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 25, 25, 25)
                                .withOpacity(0.5)),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 31, 31, 31)
                                .withOpacity(0.5)),
                      ),
                      contentPadding: const EdgeInsets.only(top: 20),
                    ),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  // child:
                ),
                const Text(
                  '  years old.   ',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.16),
            NextButton(size: size, screen: const HWScreen())
          ],
        ),
      ),
    );
  }
}
