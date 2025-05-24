import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../model/users.dart';

class UserInformationServices with ChangeNotifier {
  final currentUsers = FirebaseAuth.instance.currentUser;
  final firebaseFirestore = FirebaseFirestore.instance;

  String? userName;
  int imageCount = 0;
  int litreHesabi = 0;
  String metin = '';

   Future<void> getUserAllData() async {
    try {
      DocumentSnapshot infoSnap = await firebaseFirestore
          .collection('informations')
          .doc(currentUsers!.uid)
          .get();

      if (infoSnap.exists) {
        var data = infoSnap.data() as Map<String, dynamic>;
        Users.email = data['email'] ?? '';
        Users.username = data['username'] ?? '';
      }

      DocumentSnapshot bodySnap = await firebaseFirestore
          .collection('PersonelBodyinformations')
          .doc(currentUsers!.uid)
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
      DocumentSnapshot documentSnapshot = await firebaseFirestore
          .collection('PersonelBodyinformations')
          .doc(currentUsers!.uid)
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
  Future<void> getUsernameFromFirestore({int retry = 0}) async {
    if (currentUsers != null) {
      try {
        var userDocument = await firebaseFirestore
            .collection('informations')
            .doc(currentUsers!.uid)
            .get();

        if (userDocument.exists && userDocument.data() != null) {
          userName = userDocument.data()!['username'] ?? '';
        }
      } catch (e) {
        print("Hata oluştu getUsernameFromFirestore: $e");
        if (retry < 3) {
          await Future.delayed(Duration(seconds: 3));
          await getUsernameFromFirestore(retry: retry + 1);
        }
      }
    }
  }

  //idye göre her girişte veriyi getirme
  Future<void> getImageCount({int retry = 0}) async {
    if (currentUsers != null) {
      try {
        var userDocument = await firebaseFirestore
            .collection('Users')
            .doc(currentUsers!.uid)
            .get();

        if (userDocument.exists && userDocument.data() != null) {
          final data = userDocument.data()!;
          imageCount = data['imageCount'] ?? 0;
          litreHesabi = imageCount * 250;
          metin = litreHesabi.toString();
          notifyListeners();
        }
      } catch (e) {
        print("Hata oluştu getImageCount: $e");
        if (retry < 3) {
          await Future.delayed(Duration(seconds: 3));
          await getImageCount(retry: retry + 1);
        }
      }
    }
  }

  //veritabanından su takibindeki veriyi silme
  void removeImage() {
    if (imageCount > 0) {
      imageCount--;
      litreHesabi = imageCount * 250;
      metin = litreHesabi.toString();
      saveImageCountToFirestore(imageCount);
      notifyListeners();
    }
  }

  void addImage() {
    imageCount++;
    litreHesabi = imageCount * 250;
    metin = litreHesabi.toString();
    saveImageCountToFirestore(imageCount);
    notifyListeners();
  }

  //ıd ye göre su takibindeki resimleri veritabanına kaydetme
  Future<void> saveImageCountToFirestore(int count) async {
    if (currentUsers != null) {
      try {
        var userDocument = await firebaseFirestore
            .collection('Users')
            .doc(currentUsers!.uid)
            .get();
        if (userDocument.exists) {
          await firebaseFirestore
              .collection('Users')
              .doc(currentUsers!.uid)
              .update({
            'imageCount': count,
          });
        } else {
          await firebaseFirestore
              .collection('Users')
              .doc(currentUsers!.uid)
              .set({
            'imageCount': count,
          });
        }
      } catch (e) {
        print("Hata oluştu saveImageCountToFirestore: $e");
      }
    }
  }
}
