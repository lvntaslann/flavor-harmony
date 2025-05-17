import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<User?> authService() async {
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
      await FirebaseFirestore.instance
          .collection('informations')
          .doc(user.uid)
          .set({
        'email': user.email,
        'username': user.displayName ?? 'Google User',
      }, SetOptions(merge: true));
    }
    return user;
  } catch (e) {
    print("Google Sign-In failed: ${e.toString()}");
    return null;
  }
}
