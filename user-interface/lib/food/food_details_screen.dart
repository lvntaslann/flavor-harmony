import 'package:flutter/material.dart';

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
          child: Row(
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
              // Besin Detayları
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Besin Adı
                    Text(
                      foodItem['label'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    // Kalori Değeri
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
                          // Kalori değerini CircularProgressIndicator ile gösterme
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
                    // Diğer Besin Detayları
                    Text(
                      'Toplam Yağ: ${nutrients['FAT']} g',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Protein: ${nutrients['PROCNT']} g',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Kolesterol: ${nutrients['CHOLE']} mg',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Sodyum: ${nutrients['NA']} mg',
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      'Karbonhidrat: ${nutrients['CHOCDF']} g',
                      style: TextStyle(color: Colors.white),
                    ),
                    // Diğer besin öğelerini buraya ekleyebilirsiniz
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
