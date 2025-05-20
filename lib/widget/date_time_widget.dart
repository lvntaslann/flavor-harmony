import 'package:flavor_harmony_app/widget/show_username.dart';
import 'package:flutter/material.dart';
import 'package:flavor_harmony_app/pages/datetime_picker.dart';
class DateTimeWidget extends StatelessWidget {
  final String userName;
  final Future<void> usernameFuture;
  const DateTimeWidget(
      {Key? key, required this.userName, required this.usernameFuture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ShowUsername(userName: userName, usernameFuture: usernameFuture),
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
              Navigator.push(
      context, MaterialPageRoute(builder: (context) => DatePicker()));
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
}
