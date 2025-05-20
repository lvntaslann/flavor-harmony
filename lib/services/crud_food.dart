import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/food.dart';

class CrudFood {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;
  List<FoodItem> selectedItems = [];
  double totalCalories = 0.0;
  CrudFood(this.firestore, this.auth);

  Future<void> fetchSelectedMeals(String meal) async {
  selectedItems.clear();
  totalCalories = 0.0;
  try {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection(meal)
        .get();
    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      selectedItems.add(FoodItem(
        name: data['name'],
        imageUrl: data['imageUrl'],
        amount: data['amount'],
        calories: data['calories'],
      ));
      totalCalories += data['calories'];
    }
  } catch (e) {
    print('Error fetching selected meals: $e');
  }
}


 Future<void> saveSelectedMeal(FoodItem selectedFood,String meal) async {
  try {
    await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection(meal)
        .add({
      'name': selectedFood.name,
      'imageUrl': selectedFood.imageUrl,
      'amount': selectedFood.amount,
      'calories': selectedFood.calories,
    });
  } catch (e) {
    print('Error saving selected meal: $e');
  }
}


  Future<void> deleteSelectedMeal(FoodItem selectedFood,String meal) async {
  try {
    QuerySnapshot querySnapshot = await firestore
        .collection('users')
        .doc(auth.currentUser!.uid)
        .collection(meal)
        .where('name', isEqualTo: selectedFood.name)
        .get();

    for (var doc in querySnapshot.docs) {
      await doc.reference.delete();
    }

    selectedItems.removeWhere((item) => item.name == selectedFood.name);
    totalCalories -= selectedFood.calories;
  } catch (e) {
    print('Error deleting selected meal: $e');
  }
}

}
