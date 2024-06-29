import 'package:firebase_auth/firebase_auth.dart';
import 'package:flavor_harmony_app/screens/HomeScreen/home_page.dart';
import 'package:flavor_harmony_app/screens/auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flavor_harmony_app/screens/auth/google_sign_in.dart';
import 'package:flavor_harmony_app/screens/auth/resuable_widget.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  late String email = _emailTextController.text;
  late String password = _passwordTextController.text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 31, 31, 31),
                Color.fromARGB(255, 31, 31, 31)
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 60.0, left: 22),
              child: Text(
                'Hello\nLog in!',
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 200,
            ),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  )),
              height: double.infinity,
              width: double.infinity,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/loginandsignscreen.png',
                        height: 270,
                        width: 270,
                      ),
                      reusableTextField("Enter Username", Icons.person_outline,
                          false, _emailTextController),
                      sizedBox(),
                      reusableTextField("Enter PassWord", Icons.lock_outline,
                          true, _passwordTextController),
                      sizedBox(),
                      signInSignUpButton(context, true, () async {
                        try {
                          await FirebaseAuth.instance
                              .signInWithEmailAndPassword(
                            email: _emailTextController.text,
                            password: _passwordTextController.text,
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Login Successful"),
                                content: Text("Welcome to the app!"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                          );
                        } catch (error) {
                          String errorMessage =
                              "Login failed. Please check your email and password.";

                          if (error is FirebaseAuthException) {
                            switch (error.code) {
                              case 'user-not-found':
                                errorMessage =
                                    "User not found. Please check your email.";
                                break;
                              case 'wrong-password':
                                errorMessage =
                                    "Wrong password. Please check your password.";
                                break;
                              default:
                                errorMessage =
                                    "An error occurred. Please try again later.";
                            }
                          }
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Login Failed"),
                                content: Text(errorMessage),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("OK"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }),
                      signUpOption(context),
                      sizedBox(),
                      googleSignIn(context) // Google Sign-In
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SizedBox sizedBox() {
    return SizedBox(
      height: 20,
    );
  }
}

Row signUpOption(BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      const Text("Don't have account?", style: TextStyle(color: Colors.grey)),
      GestureDetector(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SignUpScreen()));
        },
        child: const Text(
          " Sign Up",
          style: TextStyle(
              color: Color.fromARGB(255, 31, 31, 31),
              fontWeight: FontWeight.bold),
        ),
      )
    ],
  );
}

Widget googleSignIn(BuildContext context) {
  return GestureDetector(
    onTap: () async {
      final user = await authService(context);
      if (user != null) {
        // User has been handled in authService, so no need for further navigation here
      } else {
        // Notify user about the sign-in failure
        print("Google Sign-In failed or was canceled by the user.");
      }
    },
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: 50,
          width: 230,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(90),
            color: Colors.white,
            border: Border.all(
              color: Color.fromARGB(255, 31, 31, 31),
              width: 2.0,
            ),
          ),
          child: Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Google__G__logo.svg.png"),
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Text(
                "Sign in with Google",
                style: TextStyle(
                  color: Color.fromARGB(255, 31, 31, 31),
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
        )
      ],
    ),
  );
}
