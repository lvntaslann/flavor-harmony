import 'package:flutter/material.dart';

import '../../services/route_services.dart';

class TodayCalorieButton extends StatelessWidget {
  const TodayCalorieButton({
    super.key,
    required this.routeServices,
  });

  final RouteServices routeServices;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(7, 0, 10, 0),
      child: GestureDetector(
        onTap: () {
          routeServices.todayCal(context);
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
    );
  }
}