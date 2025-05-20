
import 'package:flavor_harmony_app/pages/food_details_screen.dart';
import 'package:flutter/material.dart';

import '../services/edamam-api-services.dart';

class SearchScreen extends StatefulWidget {
  final String query;

  SearchScreen({required this.query});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> searchResults = [];
  EdamamApi edamamApi = EdamamApi();
  @override
  void initState() {
    super.initState();
    searchFoods(widget.query);
  }

  void searchFoods(String query) async {
    var results = await edamamApi.searchFoods(query);
    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Arama Sonuçları'),
        backgroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 34, 0, 114),
              Color.fromARGB(255, 28, 7, 63),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            var foodItem = searchResults[index]['food'];
            var nutrients = foodItem['nutrients'];
            var imageUrl = foodItem['image'];
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodDetailScreen(foodItem: foodItem),
                  ),
                );
              },
              leading: imageUrl != null
                  ? Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(imageUrl),
                        ),
                      ),
                    )
                  : SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.image),
                    ),
              title: Text(
                foodItem['label'],
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Kalori: ${nutrients['ENERC_KCAL']} kcal',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Protein: ${nutrients['PROCNT']} g',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Yağ: ${nutrients['FAT']} g',
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    'Karbonhidrat: ${nutrients['CHOCDF']} g',
                    style: TextStyle(color: Colors.white),
                  ),
                  // Diğer besin öğelerini buraya ekleyebilirsiniz
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
