import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flavor_harmony_app/pages/home-content.dart';
import 'package:flavor_harmony_app/pages/account.dart';
import 'package:flavor_harmony_app/pages/settings.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;

  List<Widget> _pages = [
    HomeContent(),
    Settings(),
    Account(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 218, 218, 218),
      appBar: appBar(),
      body: _pages[_pageIndex],
      bottomNavigationBar: CurvedNavigationBar(
        height: 50,
        backgroundColor: Color.fromARGB(255, 218, 218, 218),
        buttonBackgroundColor: const Color.fromARGB(255, 99, 97, 97),
        color: Color.fromARGB(255, 31, 31, 31),
        items: [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.settings,
            color: Colors.white,
          ),
          Icon(
            Icons.account_circle,
            color: Colors.white,
          ),
        ],
        onTap: (index) {
          setState(() {
            _pageIndex = index;
          });
        },
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Color.fromARGB(255, 31, 31, 31),
    );
  }
}
