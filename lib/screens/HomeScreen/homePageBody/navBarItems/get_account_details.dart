import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GetAccountDetail {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  GetAccountDetail(this.firestore, this.auth);

  Future<Map<String, dynamic>> getUserData() async {
    Map<String, dynamic> userData = {};
    try {
      DocumentSnapshot documentSnapshot = await firestore
          .collection('informations')
          .doc(auth.currentUser!.uid)
          .get();

      if (documentSnapshot.exists) {
        userData = documentSnapshot.data() as Map<String, dynamic>;
      } else {
        print('Belge bulunamadı');
      }
    } catch (e) {
      print('Veri alınırken bir hata oluştu: $e');
    }
    return userData;
  }

  Future<Map<String, dynamic>> getUserBodyInformation() async {
    Map<String, dynamic> bodyInfo = {};
    try {
      DocumentSnapshot documentSnapshot = await firestore
          .collection('PersonelBodyinformations')
          .doc(auth.currentUser!.uid)
          .get();

      if (documentSnapshot.exists) {
        bodyInfo = documentSnapshot.data() as Map<String, dynamic>;
      } else {
        print('Belge bulunamadı');
      }
    } catch (e) {
      print('Veri alınırken bir hata oluştu: $e');
    }
    return bodyInfo;
  }
}
