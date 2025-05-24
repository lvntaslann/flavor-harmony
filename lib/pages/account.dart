import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_harmony_app/pages/auth/login_page.dart';
import 'package:flavor_harmony_app/services/calculate_calorie.dart';
import 'package:flavor_harmony_app/services/user-information-services.dart';
import 'package:flavor_harmony_app/widget/container/calory_detail_user.dart';
import 'package:flavor_harmony_app/widget/container/information_user.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/users.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final currentUsers = FirebaseAuth.instance.currentUser;
  final firebaseFirestore = FirebaseFirestore.instance;

  late UserInformationServices accountDetail;
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
    accountDetail = UserInformationServices();
    calorieFuture = fetchCalorieData();
    loadUserData();
  }

  void loadUserData() async {
    await accountDetail.getUserAllData();
    setState(() {}); // Veriler yüklendiğinde arayüzü yenile
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
              child: CaloryDetailUser(calorieFuture: calorieFuture),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                InformationUser(text: "Username: ${Users.username}"),
                SizedBox(height: 20),
                InformationUser(text: "Email: ${Users.email}"),
                SizedBox(height: 20),
                InformationUser(text: "Age: ${Users.age}"),
                SizedBox(height: 20),
                InformationUser(text: "Gender: ${Users.gender}"),
                SizedBox(height: 20),
                InformationUser(text: "Height: ${Users.height}"),
                SizedBox(height: 20),
                InformationUser(text: "Weight: ${Users.weight}"),
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
}
