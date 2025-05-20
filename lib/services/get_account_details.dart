import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/users.dart';

class GetAccountDetail {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  Users user = Users();

  GetAccountDetail(this.firestore, this.auth);

  //user data
  Future<void> getUserAllData() async {
    try {
      DocumentSnapshot infoSnap = await firestore
          .collection('informations')
          .doc(auth.currentUser!.uid)
          .get();

      if (infoSnap.exists) {
        var data = infoSnap.data() as Map<String, dynamic>;
        Users.email = data['email'] ?? '';
        Users.username = data['username'] ?? '';
      }

      DocumentSnapshot bodySnap = await firestore
          .collection('PersonelBodyinformations')
          .doc(auth.currentUser!.uid)
          .get();

      if (bodySnap.exists) {
        var body = bodySnap.data() as Map<String, dynamic>;
        Users.age = body['age']?.toString() ?? 'null';
        Users.gender = body['gender'] ?? 'null';
        Users.height = body['height']?.toString() ?? 'null';
        Users.weight = body['weight']?.toString() ?? 'null';
      }
    } catch (e) {
      print("Kullanıcı bilgileri alınırken hata: $e");
    }
  }

  //user body information
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

  
