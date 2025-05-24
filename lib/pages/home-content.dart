// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_unnecessary_containers, non_constant_identifier_names, sized_box_for_whitespace, prefer_interpolation_to_compose_strings
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_harmony_app/services/calculate_calorie.dart';
import 'package:flavor_harmony_app/services/route_services.dart';
import 'package:flavor_harmony_app/services/user-information-services.dart';
import 'package:flavor_harmony_app/widget/container/activate_container.dart';
import 'package:flavor_harmony_app/widget/container/meal_container.dart';
import 'package:flavor_harmony_app/widget/date_time_widget.dart';
import 'package:flavor_harmony_app/widget/show_total_calory.dart';
import 'package:flavor_harmony_app/widget/text/title_text.dart';
import 'package:flavor_harmony_app/widget/textfield/my-search-bar.dart';
import 'package:flutter/material.dart';
import 'package:flavor_harmony_app/pages/auth/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../widget/button/today_calorie_button.dart';
import 'package:flavor_harmony_app/utils/meal_list.dart';

//doğru olan body
class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  late final UserInformationServices userInformationServices;
  TextEditingController _searchController = TextEditingController();
  final currentUsers = FirebaseAuth.instance.currentUser;
  final firebaseFirestore = FirebaseFirestore.instance;
  SignUpScreen kullaniciAdi = SignUpScreen();
  int i = 0;
  late Future<void> usernameFuture;
  late Future<Map<String, double>> calorieFuture;
  RouteServices routeServices = RouteServices();

  void initState() {
    super.initState();
    userInformationServices =
        Provider.of<UserInformationServices>(context, listen: false);
    usernameFuture = userInformationServices.getUsernameFromFirestore();
    calorieFuture = fetchCalorieData();
    userInformationServices.getImageCount();
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 20.0 * 2.5),
            height: size.height * 0.40,
            child: Stack(
              children: [
                Container(
                    padding:
                        EdgeInsets.only(left: 20.0, right: 20.0, bottom: 300),
                    height: size.height * 0.45 - 27,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 31, 31, 31),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(36),
                            bottomRight: Radius.circular(36))),
                    child: userInformationServices.userName == null
                        ? Center(child: CircularProgressIndicator())
                        : DateTimeWidget(
                            userName: userInformationServices.userName!,
                            usernameFuture: usernameFuture,
                          )),
                ShowTotalCalory(calorieFuture: calorieFuture),
                SizedBox(height: 200),
                MySearchBar(searchController: _searchController),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17.0),
                  child: TitleText(text: "My Meals")),
              TodayCalorieButton(routeServices: routeServices)
            ],
          ),
          SizedBox(
            height: 350,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: mealList.length,
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                final meal = mealList[index];
                return MealContainer(
                  image: meal['image']!,
                  title: meal['title']!,
                  press: () {
                    routeServices.goMealPage(context, meal['key']!);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: TitleText(text: "Add Yours Activity"),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ActivateContainer(function: () {
                  routeServices.workout(context);
                })
              ],
            ),
          ),
          SizedBox(height: 25),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: TitleText(text: "Did You Drink Water ?")),
          Column(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20.0, right: 10.0, top: 10.0),
                width: size.width * 0.8,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color.fromARGB(255, 0, 195, 217),
                ),
                child: DrinkWaterControl(),
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
                routeServices.stepCounter(context);
              },
              child: Text(
                "Step Counter",
                style: TextStyle(fontSize: 20),
              ))
        ],
      ),
    );
  }

  Consumer<UserInformationServices> DrinkWaterControl() {
    return Consumer<UserInformationServices>(
      builder: (context, userInformationServices, child) {
        return Column(
          children: [
            Text(
              userInformationServices.metin + 'ml',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children:
                    List.generate(userInformationServices.imageCount, (index) {
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
                    userInformationServices.removeImage();
                  },
                  icon: Icon(Icons.remove_circle_outline_rounded),
                ),
                IconButton(
                  onPressed: () {
                    userInformationServices.addImage();
                  },
                  icon: Icon(Icons.add_circle_outline_rounded),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
