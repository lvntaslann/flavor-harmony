import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SaveUserBodyInformations {
  Future<void> saveUserInformation({
    required String gender,
    required int age,
    required int height,
    required int weight,
  }) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await FirebaseFirestore.instance
            .collection('PersonelBodyinformations')
            .doc(user.uid)
            .set({
          'age': age,
          'gender': gender,
          'height': height,
          'weight': weight,
        });
      }
    } catch (e) {
      print('Error saving user information: $e');
    }
  }
}
