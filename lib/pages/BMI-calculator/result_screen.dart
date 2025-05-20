import 'package:flavor_harmony_app/pages/BMI-calculator/save_to_firebase.dart';
import 'package:flavor_harmony_app/pages/auth/login_page.dart';
import 'package:flavor_harmony_app/pages/home_page.dart';
import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  ResultScreen({
    super.key,
    required this.bmiResult,
    required this.resultText,
    required this.interpretation,
    required this.age,
    required this.height,
    required this.weight,
    required this.gender,
    required this.isGoogleSignIn,
  });
  final String gender;
  final int age;
  final int height;
  final int weight;
  final String bmiResult;
  final String resultText;
  final String interpretation;
  final bool isGoogleSignIn;
  final saveUserInformations = new SaveUserBodyInformations();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 31, 31, 31),
        title: const Text(
          'BMI Calculator',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        centerTitle: true,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(height: size.height * 0.1),
            Image.asset('assets/images/heart.png'),
            SizedBox(height: size.height * 0.01),
            Text(
              '$resultText\n\nBMI:',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              bmiResult,
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Text(
                interpretation,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: size.height * 0.08),
            GestureDetector(
              onTap: () async {
                await saveUserInformations.saveUserInformation(
                    gender: gender, age: age, height: height, weight: weight);
                if (isGoogleSignIn) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                } else {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SignInScreen()),
                  );
                }
              },
              child: Padding(
                padding: EdgeInsets.only(
                    right: 12.0, bottom: 30, left: size.width * 0.3),
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: size.width * 0.65,
                    height: size.height * 0.078,
                    decoration: BoxDecoration(
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: Padding(
                        // padding: EdgeInsets.only(left: size.width * 0.1),
                        padding:
                            EdgeInsets.symmetric(horizontal: size.width * 0.05),
                        child: const ListTile(
                          title: Text(
                            'Let\'s start! ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 31, 31, 31),
                                fontSize: 20),
                          ),
                          trailing: Icon(Icons.arrow_forward,
                              color: Color.fromARGB(255, 31, 31, 31)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            /*Text(
              '${age}, ${height}, ${weight},${gender}',
              style: TextStyle(color: Colors.purple),
            ),*/
          ],
        ),
      ),
    );
  }
}
