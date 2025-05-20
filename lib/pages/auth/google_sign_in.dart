import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_harmony_app/pages/BMI-calculator/gender_screen.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flavor_harmony_app/pages/home_page.dart';

Future<User?> authService(BuildContext context) async {
  try {
    final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();

    if (gUser == null) {
      // User cancelled the sign-in process
      return null;
    }

    final GoogleSignInAuthentication gAuth = await gUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: gAuth.accessToken,
      idToken: gAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

    // Save user info to Firestore
    User? user = userCredential.user;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('informations')
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        await FirebaseFirestore.instance
            .collection('informations')
            .doc(user.uid)
            .set({
          'email': user.email,
          'username': user.displayName ?? 'Google User',
        }, SetOptions(merge: true));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => GenderScreen(isGoogleSignIn: true)),
        );
      }
    }
    return user;
  } catch (e) {
    print("Google Sign-In failed: ${e.toString()}");
    return null;
  }
}
