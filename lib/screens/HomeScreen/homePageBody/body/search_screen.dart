import 'package:flavor_harmony_app/foodServicesAndModel/foodsevices/search_food_services.dart';
import 'package:flavor_harmony_app/foodServicesAndModel/foodsevices/food_details_screen.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final String query;

  SearchScreen({required this.query});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<dynamic> searchResults = [];

  @override
  void initState() {
    super.initState();
    // Edamam API'ye yiyecek verilerini sorgula
    searchFoods(widget.query);
  }

  void searchFoods(String query) async {
    var results = await EdamamApiService.searchFoods(query);
    setState(() {
      searchResults = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 67, 67, 67),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  Container _buildBody() {
    return Container(
      decoration: BoxDecoration(),
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
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text(
        'Food details',
      ),
      backgroundColor: Colors.white,
    );
  }
}
