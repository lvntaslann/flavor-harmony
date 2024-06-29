// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, non_constant_identifier_names, sized_box_for_whitespace, prefer_interpolation_to_compose_strings

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_harmony_app/screens/HomeScreen/homePageBody/body/calculate_calorie.dart';
import 'package:flavor_harmony_app/screens/HomeScreen/homePageBody/datetime_picker.dart';
import 'package:flavor_harmony_app/screens/HomeScreen/homePageBody/body/search_screen.dart';
import 'package:flavor_harmony_app/screens/HomeScreen/homePageBody/body/today_cal.dart';
import 'package:flavor_harmony_app/screens/mealScreen/food-breakfast/breakfast.dart';
import 'package:flavor_harmony_app/screens/mealScreen/food-dinner/dinner.dart';
import 'package:flavor_harmony_app/screens/mealScreen/food-launch/launch.dart';
import 'package:flavor_harmony_app/screens/mealScreen/food-snack/snack.dart';
import 'package:flavor_harmony_app/screens/step-counter/step_counter.dart';
import 'package:flavor_harmony_app/screens/activity/workout_home_screen.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flavor_harmony_app/screens/auth/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController _searchController = TextEditingController();
  final currentUsers = FirebaseAuth.instance.currentUser;
  final firebaseFirestore = FirebaseFirestore.instance;
  SignUpScreen kullaniciAdi = SignUpScreen();
  late int imageCount = 0;
  late int litreHesabi = 0;
  late String metin = '';
  List<Widget> resimler = [];
  int i = 0;
  late String userName = '';
  late Future<void> usernameFuture;
  late Future<Map<String, double>> calorieFuture;

  void initState() {
    super.initState();
    usernameFuture = getUsernameFromFirestore();
    calorieFuture = fetchCalorieData();
    getImageCount();
  }

  Future<Map<String, double>> fetchCalorieData() async {
    CalculateCalorie calculateCalorie = CalculateCalorie();
    double requiredCalories = await calculateCalorie.getCalorieRequirement();
    double consumedCalories = await calculateCalorie.getTotalConsumedCalories();
    return {
      'required': requiredCalories,
      'consumed': consumedCalories,
    };
  }

  Future<void> getUsernameFromFirestore() async {
    if (currentUsers != null) {
      try {
        var userDocument = await firebaseFirestore
            .collection('informations')
            .doc(currentUsers!.uid)
            .get();

        if (userDocument.exists && userDocument.data() != null) {
          setState(() {
            userName = userDocument.data()!['username'] ?? '';
          });
        }
      } catch (e) {
        print("Hata oluştu getUsernameFromFirestore: $e");
        await Future.delayed(Duration(seconds: 3));
        getUsernameFromFirestore();
      }
    }
  }

  //idye göre her girişte veriyi getirme
  void getImageCount() async {
    if (currentUsers != null) {
      try {
        var userDocument = await firebaseFirestore
            .collection('Users')
            .doc(currentUsers!.uid)
            .get();

        if (userDocument.exists && userDocument.data() != null) {
          setState(() {
            imageCount = userDocument.data()!['imageCount'] ?? 0;
            litreHesabi = imageCount * 250;
            metin = litreHesabi.toString();
          });
        }
      } catch (e) {
        print("Hata oluştu getImageCount: $e");
        await Future.delayed(Duration(seconds: 3));
        getImageCount();
      }
    }
  }

//veritabanından su takibindeki veriyi silme
  void removeImage() {
    if (imageCount > 0) {
      setState(() {
        imageCount--;
        litreHesabi = imageCount * 250;
        metin = litreHesabi.toString();
      });
      saveImageCountToFirestore(imageCount);
    }
  }

  void addImage() {
    setState(() {
      imageCount++;
      litreHesabi = imageCount * 250;
      metin = litreHesabi.toString();
    });
    saveImageCountToFirestore(imageCount);
  }

//ıd ye göre su takibindeki resimleri veritabanına kaydetme
  void saveImageCountToFirestore(int count) async {
    if (currentUsers != null) {
      try {
        var userDocument = await firebaseFirestore
            .collection('Users')
            .doc(currentUsers!.uid)
            .get();
        if (userDocument.exists) {
          await firebaseFirestore
              .collection('Users')
              .doc(currentUsers!.uid)
              .update({
            'imageCount': count,
          });
        } else {
          await firebaseFirestore
              .collection('Users')
              .doc(currentUsers!.uid)
              .set({
            'imageCount': count,
          });
        }
      } catch (e) {
        print("Hata oluştu saveImageCountToFirestore: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 20.0 * 2.5),
            height: size.height * 0.40,
            child: Stack(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20.0,
                    bottom: 300,
                  ),
                  height: size.height * 0.45 - 27,
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 31, 31, 31),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(36),
                          bottomRight: Radius.circular(36))),
                  child: dateTimeWidget(context),
                ),
                showTotalCalory(),
                SizedBox(
                  height: 200,
                ),
                searchBar(context),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17.0),
                child: Row(
                  children: <Widget>[
                    Baslik("My Meals"),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(7, 0, 10, 0),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodayCal(),
                      ),
                    );
                  },
                  child: Container(
                    width: 105,
                    height: 35,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Color.fromARGB(255, 0, 195, 217),
                        width: 0.5,
                      ),
                      color:
                          Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Today's Cal",
                          style: TextStyle(
                            color: Color.fromARGB(255, 31, 31, 31),
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Tanimlama(size, "assets/images/simple-breakfast.png",
                    "Breakfast", breakfast),
                Tanimlama(
                    size, "assets/images/simple-lunch.png", "Lunch", launch),
                Tanimlama(
                    size, "assets/images/simple-sneack.png", "Sneack", snack),
                Tanimlama(
                    size, "assets/images/simple-dinner.png", "Dinner", dinner),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: <Widget>[
                Baslik("Add yours activity"),
              ],
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Aktivite(size, "assets/images/activity-add-note.png", workout),
              ],
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: <Widget>[Baslik("Did you drink water ?")],
            ),
          ),
          Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0),
                width: size.width * 0.8,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 0, 195, 217),
                ),
                child: Column(
                  children: [
                    Text(
                      metin + 'ml',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(imageCount, (index) {
                          return Container(
                            margin: EdgeInsets.only(right: 8.0),
                            child: Column(
                              children: [
                                Image.asset(
                                  "assets/images/glass-removebg-preview.png",
                                  width: 50,
                                  height: 70,
                                ),
                              ],
                            ),
                          );
                        }),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            removeImage();
                          },
                          icon: Icon(Icons.remove_circle_outline_rounded),
                        ),
                        IconButton(
                          onPressed: () {
                            addImage();
                          },
                          icon: Icon(
                            Icons.add_circle_outline_rounded,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 100),
          ),
          SizedBox(
            height: 5,
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StepCounter()),
                );
              },
              child: Text(
                "Step Counter",
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
    );
  }

  Positioned searchBar(BuildContext context) {
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
            controller: _searchController,
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
                  String query = _searchController.text;
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
        ));
  }

  Positioned showTotalCalory() {
    return Positioned(
      top: 60,
      left: 100,
      child: FutureBuilder<Map<String, double>>(
        future: calorieFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('No data available'));
          }

          double calorieRequirement = snapshot.data!['required']!;
          double consumedCalories = snapshot.data!['consumed']!;

          // calorieRequirement değeri sıfır mı kontrol et
          double percent = (calorieRequirement != 0)
              ? consumedCalories / calorieRequirement
              : 0;

          return Container(
            width: 200,
            height: 200,
            child: Center(
              child: Stack(
                children: [
                  Center(
                    child: CircularPercentIndicator(
                      radius: 90.0,
                      lineWidth: 15.0,
                      circularStrokeCap: CircularStrokeCap.round,
                      percent: percent,
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$calorieRequirement",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.amber,
                              fontSize: 22,
                            ),
                          ),
                          Text(
                            "Kcal",
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            "Consumed calory",
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            "$consumedCalories Kcal",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: Color.fromARGB(255, 115, 115, 115),
                      progressColor: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Row dateTimeWidget(BuildContext context) {
    return Row(
      children: <Widget>[
        showUserName(),
        Spacer(),
        Expanded(child: Container()),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_back_ios),
          iconSize: 20,
          color: Colors.white70,
        ),
        IconButton(
          onPressed: () {
            goDatePage(context);
          },
          icon: Icon(Icons.date_range),
          iconSize: 20,
          color: Colors.white70,
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.arrow_forward_ios),
          iconSize: 20,
          color: Colors.white70,
        ),
      ],
    );
  }

  FutureBuilder<void> showUserName() {
    return FutureBuilder(
      future: usernameFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Text(
            "Hi, $userName",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  GestureDetector Aktivite(Size size, String image, Function function) {
    return GestureDetector(
      onTap: () {
        workout(context);
      },
      child: Container(
        margin: EdgeInsets.only(
          left: 20.0,
          right: 10.0,
          top: 10.0,
        ),
        width: size.width * 0.8,
        height: 185,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 218, 218, 218),
          borderRadius: BorderRadius.circular(10),
          image: DecorationImage(
            image: AssetImage("assets/images/activity-add-note.png"),
          ),
        ),
      ),
    );
  }

  Widget Tanimlama(Size size, String image, String title, Function press) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        press(context);
      },
      child: Container(
        color: Color.fromARGB(255, 218, 218, 218),
        margin: EdgeInsets.only(left: 20.0, right: 10.0, bottom: 50.0, top: 7),
        width: size.width * 0.6,
        child: Column(
          children: <Widget>[
            Image.asset(image),
            GestureDetector(
              onTap: () {
                press(context);
              },
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.amber,
                    boxShadow: [
                      BoxShadow(
                          offset: Offset(0, 15),
                          blurRadius: 10,
                          color:
                              Color.fromARGB(255, 34, 0, 114).withOpacity(0.2))
                    ]),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: title.toUpperCase(),
                          style: Theme.of(context).textTheme.titleMedium),
                    ]))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget Baslik(String text) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.fromLTRB(17, 0, 0, 0),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 218, 218, 218),
            borderRadius: BorderRadius.circular(5)),
        height: size.height * 0.08 - 31,
        width: size.width * 0.4 + 69,
        child: Stack(
          children: <Widget>[
            Text(
              text,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Color.fromARGB(255, 67, 67, 67)),
            ),
          ],
        ),
      ),
    );
  }
}

void breakfast(BuildContext context) {
  try {
    // Navigator'ı kullanarak breakfast.dart sayfasına geçiş yapma
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BreakfastPage()),
    );
  } catch (e) {
    print("Hata oluştu press: $e");
  }
}

void launch(BuildContext context) {
  try {
    // Navigator'ı kullanarak breakfast.dart sayfasına geçiş yapma
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Launch()),
    );
  } catch (e) {
    print("Hata oluştu press: $e");
  }
}

void snack(BuildContext context) {
  try {
    // Navigator'ı kullanarak breakfast.dart sayfasına geçiş yapma
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Snack()),
    );
  } catch (e) {
    print("Hata oluştu press: $e");
  }
}

void dinner(BuildContext context) {
  try {
    // Navigator'ı kullanarak breakfast.dart sayfasına geçiş yapma
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Dinner()),
    );
  } catch (e) {
    print("Hata oluştu press: $e");
  }
}

void workout(BuildContext context) {
  try {
    // Navigator'ı kullanarak breakfast.dart sayfasına geçiş yapma
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => WorkoutHomeScreen()),
    );
  } catch (e) {
    print("Hata oluştu press: $e");
  }
}

void goDatePage(BuildContext context) {
  Navigator.push(
      context, MaterialPageRoute(builder: (context) => DatePicker()));
}
