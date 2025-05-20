import 'package:flutter/material.dart';

import '../../pages/search_screen.dart';

class MySearchBar extends StatelessWidget {
  final TextEditingController searchController;
  const MySearchBar({Key? key, required this.searchController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        height: 54,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 10),
                blurRadius: 10,
                color: Color.fromARGB(255, 34, 0, 114).withOpacity(0.23),
              )
            ]),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: "Ara",
            hintStyle: TextStyle(
              color: Color.fromARGB(255, 34, 0, 114).withOpacity(0.5),
            ),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            suffixIcon: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // TextField'da yazılan metni al ve arama işlemini başlat
                String query = searchController.text;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchScreen(
                        query:
                            query), // Burada SearchScreen olarak düzeltilmiş.
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
