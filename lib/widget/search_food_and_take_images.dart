import 'dart:io';
import 'package:flutter/material.dart';
import '../model/food.dart';
import '../pages/takeImages.dart';
import '../services/edamam-api-services.dart';


class SearchFoodAndTakeImages extends StatelessWidget {
  final TextEditingController searchController;
  final EdamamApi edamamApiService;
  final void Function(List<FoodItem>) onResults;
  final void Function(File) onImageSelected;

  const SearchFoodAndTakeImages({
    Key? key,
    required this.searchController,
    required this.edamamApiService,
    required this.onResults,
    required this.onImageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Search for food',
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: () async {
                  String query = searchController.text.trim();
                  if (query.isNotEmpty) {
                    List<FoodItem> results =
                        await edamamApiService.fetchFoodItems(query);
                    onResults(results);
                  }
                },
              ),
            ),
          ),
        ),
        TakeImages(
          onImageSelected: onImageSelected,
        ),
      ],
    );
  }
}
