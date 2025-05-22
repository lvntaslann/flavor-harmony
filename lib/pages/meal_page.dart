import 'dart:io';
import 'package:flavor_harmony_app/model/ai_model.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/food.dart';
import '../services/crud_food.dart';
import '../services/edamam-api-services.dart';
import 'package:flavor_harmony_app/widget/search_food_and_take_images.dart';
import 'package:flavor_harmony_app/widget/eaten_meals.dart';

class MealPage extends StatefulWidget {
  final String meal;

  const MealPage({Key? key, required this.meal}) : super(key: key);
  @override
  _MealPageState createState() => _MealPageState();
}

class _MealPageState extends State<MealPage> {
  final EdamamApi edamamApiService = EdamamApi();
  late CrudFood crudFood;
  List<FoodItem> _searchResults = [];

  TextEditingController _searchController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  double totalCalories = 0.0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    crudFood = CrudFood(_firestore, FirebaseAuth.instance);
    _getUser();
  }

  void classifyAndAddFood(File imageFile) async {
    AiModel foodModel = AiModel();
    final EdamamApi edamamApi = EdamamApi();

    String? foodClass = await foodModel.classifyFood(imageFile);

    if (foodClass != null) {
      List<FoodItem> foodItems = await edamamApi.fetchFoodItems(foodClass);
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
    _auth.authStateChanges().listen((User? user) async {
      if (user != null) {
        await crudFood.fetchSelectedMeals('meal_${widget.meal}');
        setState(() {
          crudFood.selectedItems = List.from(crudFood.selectedItems);
          totalCalories = crudFood.totalCalories;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.meal.toUpperCase()),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: SearchFoodAndTakeImages(
              searchController: _searchController,
              edamamApiService: edamamApiService,
              onResults: (results) {
                setState(() {
                  _searchResults = results;
                  _searchController.clear();
                });
              },
              onImageSelected: (File image) {
                classifyAndAddFood(image);
              },
            ),
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
                                if (!crudFood.selectedItems.any(
                                    (item) => item.name == selectedFood.name)) {
                                  setState(() {
                                    crudFood.selectedItems.add(selectedFood);
                                    totalCalories += selectedFood.calories;
                                    _amountController.clear();
                                    Navigator.pop(context);
                                  });
                                  try {
                                    await crudFood.saveSelectedMeal(
                                        selectedFood, 'meal_${widget.meal}');
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Item added successfully')),
                                    );
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('failed to add item')),
                                    );
                                  }
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
          EatenMeals(
            crudFood: crudFood,
            totalCalories: totalCalories,
            mealKey: 'meal_${widget.meal}',
            isLoading: _isLoading,
            setLoading: (val) => setState(() => _isLoading = val),
          ),
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
