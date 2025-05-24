import 'package:flutter/material.dart';
import 'package:flavor_harmony_app/utils/nutrient_keys.dart';

class FoodDetailScreen extends StatelessWidget {
  final Map<String, dynamic> foodItem;

  FoodDetailScreen({required this.foodItem});

  @override
  Widget build(BuildContext context) {
    var nutrients = foodItem['nutrients'];
    var imageUrl = foodItem['image'];

    return Scaffold(
      appBar: AppBar(
        title: Text('Besin Detayları'),
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
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ListView(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ürün Resmi
                  imageUrl != null
                      ? Container(
                          width: 150,
                          height: 150,
                          margin: EdgeInsets.only(right: 20.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(imageUrl),
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 150,
                          height: 150,
                          child: Icon(Icons.image),
                        ),
                  // Besin Adı ve Kalori
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          foodItem['label'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Row(
                            children: [
                              Text(
                                'Kalori: ',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              SizedBox(
                                width: 30,
                                height: 30,
                                child: CircularProgressIndicator(
                                  value: nutrients['ENERC_KCAL'] / 1000,
                                  strokeWidth: 5,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.blue,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              Text(
                                '${nutrients['ENERC_KCAL']} kcal',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Besin detaylarını dinamik olarak göster
              ListView.builder(
                itemCount: nutrientLabels.length,
                itemBuilder: (context, index) {
                  return Text(
                    '${nutrientLabels[index]}: ${nutrients[nutrientKeys[index]]} ${nutrientUnits[index]}',
                    style: TextStyle(color: Colors.white),
                  );
                },
              ),
              // Diğer besin öğelerini buraya ekleyebilirsiniz
            ],
          ),
        ),
      ),
    );
  }
}
