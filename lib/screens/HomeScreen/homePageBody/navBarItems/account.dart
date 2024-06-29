import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_harmony_app/screens/auth/login_page.dart';
import 'package:flavor_harmony_app/screens/HomeScreen/homePageBody/body/calculate_calorie.dart';
import 'package:flavor_harmony_app/screens/HomeScreen/homePageBody/navBarItems/get_account_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final currentUsers = FirebaseAuth.instance.currentUser;
  final firebaseFirestore = FirebaseFirestore.instance;
  String email = '';
  String username = '';
  int age = 0;
  String gender = '';
  int height = 0;
  int weight = 0;

  late GetAccountDetail accountDetail;
  late Future<Map<String, double>> calorieFuture;

  Future<Map<String, double>> fetchCalorieData() async {
    CalculateCalorie calculateCalorie = CalculateCalorie();
    double requiredCalories = await calculateCalorie.getCalorieRequirement();
    double consumedCalories = await calculateCalorie.getTotalConsumedCalories();
    return {
      'required': requiredCalories,
      'consumed': consumedCalories,
    };
  }

  @override
  void initState() {
    super.initState();
    accountDetail = GetAccountDetail(firebaseFirestore, FirebaseAuth.instance);
    calorieFuture = fetchCalorieData();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    var userData = await accountDetail.getUserData();
    var bodyInfo = await accountDetail.getUserBodyInformation();

    setState(() {
      email = userData['email'] ?? '';
      username = userData['username'] ?? '';
      age = bodyInfo['age'] ?? 0;
      gender = bodyInfo['gender'] ?? '';
      height = bodyInfo['height'] ?? 0;
      weight = bodyInfo['weight'] ?? 0;
    });
  }

  void signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
      );
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 218, 218),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: getCaloryDetailUser(),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                informationsUser("Username: $username"),
                SizedBox(height: 20),
                informationsUser("Email: $email"),
                SizedBox(height: 20),
                informationsUser("Age: $age"),
                SizedBox(height: 20),
                informationsUser("Gender: $gender"),
                SizedBox(height: 20),
                informationsUser("Height: $height"),
                SizedBox(height: 20),
                informationsUser("Weight: $weight"),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  backgroundColor: Color.fromARGB(255, 34, 0, 114),
                  onPressed: () {
                    signOut(context);
                  },
                  child: Icon(
                    Icons.logout_sharp,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget getCaloryDetailUser() {
    return FutureBuilder<Map<String, double>>(
      future: calorieFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData) {
          return Center(child: Text('No data available'));
        }

        double calorieRequirement = snapshot.data!['required']!;
        double consumedCalories = snapshot.data!['consumed']!;

        // calorieRequirement değeri sıfır mı kontrol et
        double percent = (calorieRequirement != 0)
            ? consumedCalories / calorieRequirement
            : 0;

        return Container(
          width: 200,
          height: 200,
          child: Center(
            child: Stack(
              children: [
                Center(
                  child: CircularPercentIndicator(
                    radius: 80.0,
                    lineWidth: 15.0,
                    circularStrokeCap: CircularStrokeCap.round,
                    percent: percent,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "$calorieRequirement",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          "Kcal",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Consumed calory",
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "$consumedCalories Kcal",
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    backgroundColor: Color.fromARGB(255, 115, 115, 115),
                    progressColor: Colors.amber,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Container informationsUser(String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: TextStyle(
            color: Color.fromARGB(255, 67, 67, 67),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
