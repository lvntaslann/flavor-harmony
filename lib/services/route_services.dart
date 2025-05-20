import 'package:flavor_harmony_app/pages/meal_page.dart';
import 'package:flavor_harmony_app/pages/step-counter/step_counter.dart';
import 'package:flavor_harmony_app/pages/today_cal.dart';
import 'package:flutter/material.dart';
import '../pages/activity/workout_home_screen.dart';


class RouteServices {
  void goMealPage(BuildContext context,String meal) {
    try {
      // Navigator'ı kullanarak breakfast.dart sayfasına geçiş yapma
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MealPage(meal: meal)),
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

  void todayCal(BuildContext context) {
    try {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TodayCal(),
        ),
      );
    } catch (e) {
      print("Hata oluştu $e");
    }
  }

  void stepCounter(BuildContext context){
    try{
      Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StepCounter()),
                );
    }catch(e){
      print(e);
    }
  }
}
