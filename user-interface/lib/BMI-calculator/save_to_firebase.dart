import 'package:cloud_firestore/cloud_firestore.dart';

class SaveToFirebase {
  static void saveUserInfoToFirestore(
      String userId, String gender, int age, int height, int weight) async {
    try {
      // Firestore referansı al
      CollectionReference userCollection =
          FirebaseFirestore.instance.collection('PersonelBodyinformations');

      // Belirli bir kullanıcı kimliğine sahip belgeyi oluştur ve bilgileri ekle
      await userCollection.doc(userId).set({
        'gender': gender,
        'age': age,
        'height': height,
        'weight': weight,
      });

      print('Kullanıcı bilgileri başarıyla Firestore\'a kaydedildi.');
    } catch (e) {
      print(
          'Kullanıcı bilgilerini Firestore\'a kaydederken bir hata oluştu: $e');
    }
  }
}
