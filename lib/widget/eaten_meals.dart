import 'package:flutter/material.dart';
import '../services/crud_food.dart';

class EatenMeals extends StatelessWidget {
  final CrudFood crudFood;
  final double totalCalories;
  final String mealKey;
  final bool isLoading;
  final void Function(bool) setLoading;

  const EatenMeals({
    Key? key,
    required this.crudFood,
    required this.totalCalories,
    required this.mealKey,
    required this.isLoading,
    required this.setLoading,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            itemCount: crudFood.selectedItems.length,
            itemBuilder: (context, index) {
              return ListTile(
                leading: crudFood.selectedItems[index].imageUrl != null
                    ? Image.network(
                        crudFood.selectedItems[index].imageUrl!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      )
                    : SizedBox(
                        width: 50,
                        height: 50,
                        child: Placeholder(),
                      ),
                title: Text(crudFood.selectedItems[index].name),
                subtitle:
                    Text('${crudFood.selectedItems[index].calories} kcal'),
                trailing: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          'Amount: ${crudFood.selectedItems[index].amount}g',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          setLoading(true);
                          await crudFood.deleteSelectedMeal(
                              crudFood.selectedItems[index], mealKey);
                          setLoading(false);
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
}
