import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_harmony_app/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    try {
      // Firestore instance'ını oluşturun
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Kullanıcı belgelerini almak için sorguyu oluşturun
      DocumentSnapshot documentSnapshot = await firestore
          .collection('informations')
          .doc(currentUsers!.uid)
          .get();

      // Belgeyi kontrol et
      if (documentSnapshot.exists) {
        // Belge bulundu ise verileri al
        var data = documentSnapshot.data() as Map<String, dynamic>;

        setState(() {
          email = data['email'];
          username = data['username'];
        });
      } else {
        // Belge bulunamadıysa hata mesajı yazdır
        print('Belge bulunamadı');
      }
    } catch (e) {
      print('Veri alınırken bir hata oluştu: $e');
    }
  }

  void signOut(BuildContext context) async {
    try {
      // Sign out from FirebaseAuth
      await FirebaseAuth.instance.signOut();

      // Sign out from GoogleSignIn
      await GoogleSignIn().signOut();

      // Navigate to the SignInScreen
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.deepPurple,
                ),
              ),
            ),
            ListView(
              shrinkWrap: true,
              children: [
                informationsUser("Username: $username"),
                SizedBox(
                  height: 20,
                ),
                informationsUser("Email: $email"),
                SizedBox(
                  height: 20,
                ),
                informationsUser("Age: null"),
                SizedBox(
                  height: 20,
                ),
                informationsUser("Gender: null"),
                SizedBox(
                  height: 20,
                ),
                informationsUser("Height: null"),
                SizedBox(
                  height: 20,
                ),
                informationsUser("Weight: null"),
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

  Container informationsUser(String text) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10)),
      child: Text(
        text,
        style: TextStyle(
            color: Colors.deepPurple,
            fontSize: 20,
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
