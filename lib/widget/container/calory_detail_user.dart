import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class CaloryDetailUser extends StatelessWidget {
  final Future<Map<String, double>> calorieFuture;
  const CaloryDetailUser({Key? key, required this.calorieFuture}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, double>>(
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
                    radius: 80.0,
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
                          style: TextStyle(color: Colors.black),
                        ),
                        Text(
                          "$consumedCalories Kcal",
                          style: TextStyle(
                            color: Colors.amber,
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
    );
  }
}
