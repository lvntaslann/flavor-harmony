import 'package:flutter/material.dart';

class ShowUsername extends StatelessWidget {
  final String userName;
  final Future<void> usernameFuture;
  const ShowUsername(
      {Key? key, required this.userName, required this.usernameFuture})
      : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
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
}
