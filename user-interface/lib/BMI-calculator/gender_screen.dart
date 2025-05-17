import 'package:flavor_harmony_app/BMI-calculator/age_screen.dart';
import 'package:flavor_harmony_app/BMI-calculator/next_text_button.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool mIsChecked = false;
  bool fIsChecked = false;
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
      body: Column(
        children: [
          TextContainer(
            size: size,
            text: 'I am a ',
            lottieAnimationLink:
                'https://lottie.host/966eb986-f8ca-4e61-8fec-813adb62216b/q3yCkQ4k2w.json',
          ),
          const SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Column(
                children: [
                  const CircleImage(gender: 'male'),
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      value: mIsChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          if (fIsChecked == true) {
                            fIsChecked = false;
                          }
                          mIsChecked = value!;
                        });
                        setState(() {});
                        // print('isChecked: $isChecked');
                      },
                      // activeColor: Colors.green,
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Color.fromARGB(255, 25, 25, 25)
                              .withOpacity(.32);
                        }
                        return Color.fromARGB(255, 31, 31, 31);
                      }),
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                  ),
                  const Text(
                    'Male',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const CircleImage(gender: 'female'),
                  Transform.scale(
                    scale: 1.5,
                    child: Checkbox(
                      value: fIsChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          if (mIsChecked == true) {
                            mIsChecked = false;
                          }
                          fIsChecked = value!;
                        });
                        setState(
                          () {},
                        );
                        // print('isChecked: $isChecked');
                      },
                      // activeColor: Colors.green,
                      fillColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.disabled)) {
                          return Color.fromARGB(255, 25, 25, 25)
                              .withOpacity(.32);
                        }
                        return Color.fromARGB(255, 31, 31, 31);
                      }),
                      materialTapTargetSize: MaterialTapTargetSize.padded,
                    ),
                  ),
                  const Text(
                    'Female',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: size.height * 0.16),
          NextButton(size: size, screen: const AgeScreen()),
        ],
      ),
    );
  }
}

class CircleImage extends StatelessWidget {
  const CircleImage({
    Key? key,
    required this.gender,
  }) : super(key: key);

  final String gender;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 40,
      backgroundColor: Colors.white,
      child: CircleAvatar(
        radius: 35,
        backgroundColor: Colors.white,
        backgroundImage: AssetImage('assets/images/$gender.png'),
      ),
    );
  }
}
