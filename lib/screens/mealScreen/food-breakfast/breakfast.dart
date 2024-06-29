import 'dart:io';
import 'package:flavor_harmony_app/foodServicesAndModel/modelServices/model.dart';
import 'package:flavor_harmony_app/foodServicesAndModel/modelServices/takeImages.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_harmony_app/screens/mealScreen/food-breakfast/food_api_service.dart';

class BreakfastPage extends StatefulWidget {
  @override
  _BreakfastPageState createState() => _BreakfastPageState();
}

class _BreakfastPageState extends State<BreakfastPage> {
  final FoodApiService _foodApiService = FoodApiService();
  List<FoodItem> _searchResults = [];
  List<FoodItem> _selectedItems = [];
  TextEditingController _searchController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  double totalCalories = 0.0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User _user; // Firestore kullanıcı kimliğini tutmak için
  bool _isLoading = false; // Eklenen ve Silinen öğeler için yükleme göstergesi

  @override
  void initState() {
    super.initState();
    _getUser(); // Kullanıcıyı almak için fonksiyon
  }

  void classifyAndAddFood(File imageFile) async {
    FoodModel foodModel =
        FoodModel(); // FoodModel sınıfından bir nesne oluşturuldu
    FoodApiService foodApiService = FoodApiService();

    // Yiyeceği sınıflandır
    String? foodClass = await foodModel.classifyFood(imageFile);

    if (foodClass != null) {
      List<FoodItem> foodItems = await foodApiService.fetchFoodItems(foodClass);
      if (foodItems.isNotEmpty) {
        FoodItem foodItem = foodItems.first;

        setState(() {
          _searchResults.add(
            FoodItem(
              name: foodItem.name,
              calories: foodItem.calories,
              imageUrl: foodItem.imageUrl,
            ),
          );
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to get food information')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to classify food')),
      );
    }
  }

  void _getUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        setState(() {
          _user = user;
          fetchSelectedMeals(); // Kullanıcı alındıktan sonra verileri çekin
        });
      }
    });
  }

  Future<void> fetchSelectedMeals() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(_user.uid)
          .collection('meal_breakfast')
          .get();
      querySnapshot.docs.forEach((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          _selectedItems.add(
            FoodItem(
              name: data['name'],
              imageUrl: data['imageUrl'],
              amount: data['amount'],
              calories: data['calories'],
            ),
          );
          totalCalories += data['calories'];
        });
      });
    } catch (e) {
      print('Error fetching selected meals: $e');
    }
  }

  Future<void> saveSelectedMeal(FoodItem selectedFood) async {
    try {
      setState(() {
        _isLoading = true;
      });
      DocumentReference docRef = await _firestore
          .collection('users')
          .doc(_user.uid)
          .collection('meal_breakfast')
          .add({
        'name': selectedFood.name,
        'imageUrl': selectedFood.imageUrl,
        'amount': selectedFood.amount,
        'calories': selectedFood.calories,
      });
      print('Selected meal saved to Firestore with ID: ${docRef.id}');
      setState(() {
        _selectedItems.add(selectedFood);
        totalCalories += selectedFood.calories;
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Item added successfully')),
      );
    } catch (e) {
      print('Error saving selected meal: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> deleteSelectedMeal(FoodItem selectedFood) async {
    try {
      setState(() {
        _isLoading = true;
      });
      QuerySnapshot querySnapshot = await _firestore
          .collection('users')
          .doc(_user.uid)
          .collection('meal_breakfast')
          .where('name', isEqualTo: selectedFood.name)
          .get();
      querySnapshot.docs.forEach((doc) async {
        await doc.reference.delete();
        print('Selected meal deleted from Firestore: ${doc.id}');
        setState(() {
          _selectedItems.removeWhere((item) => item.name == selectedFood.name);
          totalCalories -= selectedFood.calories;
          _isLoading = false;
        });
      });
    } catch (e) {
      print('Error deleting selected meal: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breakfast'),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: searchFoodAndTakeImages(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: _searchResults[index].imageUrl != null
                      ? Image.network(
                          _searchResults[index].imageUrl!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : SizedBox(
                          width: 50,
                          height: 50,
                          child: Placeholder(),
                        ),
                  title: Text(_searchResults[index].name),
                  subtitle: Text('${_searchResults[index].calories} kcal'),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Enter Amount'),
                          content: TextField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Amount (grams)',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () async {
                                double amount = double.tryParse(
                                        _amountController.text.trim()) ??
                                    0.0;
                                FoodItem selectedFood = _searchResults[index]
                                    .copyWithAmount(amount);
                                if (!_selectedItems.any(
                                    (item) => item.name == selectedFood.name)) {
                                  setState(() {
                                    _selectedItems.add(selectedFood);
                                    totalCalories += selectedFood.calories;
                                    _amountController.clear();
                                    Navigator.pop(context);
                                  });
                                  await saveSelectedMeal(selectedFood);
                                }
                              },
                              child: Text('Add'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          eatenMeals(),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  Container eatenMeals() {
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
            'Selected Items',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          SizedBox(height: 10),
          ListView.builder(
            shrinkWrap: true,
            itemCount: _selectedItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: _selectedItems[index].imageUrl != null
                    ? Image.network(
                        _selectedItems[index].imageUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(
                        width: 50,
                        height: 50,
                        child: Placeholder(),
                      ),
                title: Text(_selectedItems[index].name),
                subtitle: Text('${_selectedItems[index].calories} kcal'),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          'Amount: ${_selectedItems[index].amount}g',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          deleteSelectedMeal(_selectedItems[index]);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 10),
          Text(
            'Total Calories: $totalCalories kcal',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Row searchFoodAndTakeImages() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              labelText: 'Search for food',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  String query = _searchController.text.trim();
                  List<FoodItem> results =
                      await _foodApiService.fetchFoodItems(query);
                  setState(() {
                    _searchResults = results;
                  });
                },
              ),
            ),
          ),
        ),
        TakeImages(
          onImageSelected: (File image) {
            classifyAndAddFood(image);
          },
        ),
      ],
    );
  }
}

extension FoodItemExtension on FoodItem {
  FoodItem copyWithAmount(double newAmount) {
    return FoodItem(
      name: this.name,
      calories: this.calories * newAmount / 100,
      imageUrl: this.imageUrl,
      amount: newAmount,
    );
  }
}
