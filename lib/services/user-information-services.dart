import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserInformationServices with ChangeNotifier {
  final currentUsers = FirebaseAuth.instance.currentUser;
  final firebaseFirestore = FirebaseFirestore.instance;
  String? userName;
  int imageCount = 0;
  int litreHesabi = 0;
  String metin = '';
  Future<void> getUsernameFromFirestore() async {
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
        await Future.delayed(Duration(seconds: 3));
        getUsernameFromFirestore();
      }
    }
  }

  //idye göre her girişte veriyi getirme
void getImageCount() async {
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
        notifyListeners(); // BURADA OLMALI
      }
    } catch (e) {
      print("Hata oluştu getImageCount: $e");
      await Future.delayed(Duration(seconds: 3));
      getImageCount();
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
    }
    notifyListeners();
  }

  void addImage() {
    imageCount++;
    litreHesabi = imageCount * 250;
    metin = litreHesabi.toString();
    saveImageCountToFirestore(imageCount);
    notifyListeners();
  }

//ıd ye göre su takibindeki resimleri veritabanına kaydetme
  void saveImageCountToFirestore(int count) async {
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
    notifyListeners();
  }
}
