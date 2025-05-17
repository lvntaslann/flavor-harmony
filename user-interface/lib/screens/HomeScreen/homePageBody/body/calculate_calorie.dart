import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalculateCalorie {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<double> getCalorieRequirement() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        print('User ID: ${user.uid}');
        final doc = await _firestore
            .collection('PersonelBodyinformations')
            .doc(user.uid)
            .get();
        if (doc.exists && doc.data() != null) {
          print('Document data: ${doc.data()}');
          final data = doc.data()!;
          final int age = data['age'] ?? 0;
          final String gender = data['gender'] ?? 'male';
          final double height =
              (data['height'] as num).toDouble(); // Casting to num first
          final double weight =
              (data['weight'] as num).toDouble(); // Casting to num first

          double calories;
          if (gender == 'male') {
            calories = (10 * weight + 6.25 * height - 5 * age + 5);
          } else {
            calories = (10 * weight + 6.25 * height - 5 * age - 161);
          }
          print('Calories calculated: $calories');
          return calories;
        } else {
          print('Document does not exist or no data');
        }
      } else {
        print('User is null');
      }
      return 0;
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  Future<double> getTotalConsumedCalories() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        double totalCalories = 0.0;
        totalCalories += await fetchMeals('meal_breakfast');
        totalCalories += await fetchMeals('meal_launch');
        totalCalories += await fetchMeals('meal_snack');
        totalCalories += await fetchMeals('meal_dinner');
        return totalCalories;
      }
      return 0;
    } catch (e) {
      print('Error: $e');
      return 0;
    }
  }

  Future<double> fetchMeals(String mealType) async {
    double mealCalories = 0.0;
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .collection(mealType)
          .get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        mealCalories +=
            (data['calories'] as num).toDouble(); // Casting to num first
      }
    } catch (e) {
      print('Error fetching $mealType: $e');
    }
    return mealCalories;
  }
}
