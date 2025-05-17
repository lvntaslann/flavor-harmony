import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_harmony_app/food-breakfast/food_api_service.dart';
import 'package:flutter/material.dart';

class TodayCal extends StatefulWidget {
  const TodayCal({Key? key}) : super(key: key);

  @override
  _TodayCalState createState() => _TodayCalState();
}

class _TodayCalState extends State<TodayCal> {
  List<FoodItem> _breakfastItems = [];
  List<FoodItem> _lunchItems = [];
  List<FoodItem> _snackItems = [];
  List<FoodItem> _dinnerItems = [];
  double totalCalories = 0.0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user;
  bool _isLoading = true; // Initialize loading state

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  void _getUser() {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _user = user;
        fetchAllMeals();
      }
    });
  }

  Future<void> fetchAllMeals() async {
    await fetchMeals('meal_breakfast', _breakfastItems);
    await fetchMeals('meal_launch', _lunchItems);
    await fetchMeals('meal_snack', _snackItems);
    await fetchMeals('meal_dinner', _dinnerItems);

    if (mounted) {
      // Ensure the widget is still in the tree before calling setState
      setState(() {
        totalCalories =
            _breakfastItems.fold(0.0, (sum, item) => sum + item.calories) +
                _lunchItems.fold(0.0, (sum, item) => sum + item.calories) +
                _snackItems.fold(0.0, (sum, item) => sum + item.calories) +
                _dinnerItems.fold(0.0, (sum, item) => sum + item.calories);
        _isLoading = false; // Update loading state
      });
    }
  }

  Future<void> fetchMeals(String mealType, List<FoodItem> itemsList) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(_user.uid)
          .collection(mealType)
          .get();
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        itemsList.add(
          FoodItem(
            name: data['name'],
            imageUrl: data['imageUrl'],
            amount: data['amount'].toDouble(), // Ensure amount is double
            calories: data['calories'].toDouble(), // Ensure calories are double
          ),
        );
      }
    } catch (e) {
      print('Error fetching $mealType: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 195, 217),
        title: Text(
          'Today\'s Calories',
          style: TextStyle(
            color: Color.fromARGB(255, 31, 31, 31),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Text(
                    'Total Calories: $totalCalories kcal',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.white),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        getInformationsMealFromFirebase(
                            "Breakfast", _breakfastItems),
                        getInformationsMealFromFirebase("Lunch", _lunchItems),
                        getInformationsMealFromFirebase("Snack", _snackItems),
                        getInformationsMealFromFirebase("Dinner", _dinnerItems),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Container getInformationsMealFromFirebase(String meal, List<FoodItem> items) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$meal',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color.fromARGB(255, 0, 195, 217),
            ),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: items[index].imageUrl != null
                    ? Image.network(
                        items[index].imageUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(
                        width: 50,
                        height: 50,
                        child: Placeholder(),
                      ),
                title: Text(
                  items[index].name,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  '${items[index].calories} kcal',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          'Amount: ${items[index].amount}g',
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Ensure any subscriptions are canceled to prevent memory leaks
    super.dispose();
  }
}
