import 'package:flavor_harmony_app/pages/welcome_screen.dart/intro_screens/intro_page_1.dart';
import 'package:flavor_harmony_app/pages/welcome_screen.dart/intro_screens/intro_page_2.dart';
import 'package:flavor_harmony_app/pages/welcome_screen.dart/intro_screens/intro_page_3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:flavor_harmony_app/pages/auth/login_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  bool onLastPage = false;
  PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          //pageview
          PageView(
            controller: _controller,
            onPageChanged: (index) {
              setState(() {
                onLastPage = (index == 2);
              });
            },
            children: [IntroPage1(), IntroPage2(), IntroPage3()],
          ),
          //dot indicators
          Container(
            alignment: Alignment(0, 0.87),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                //skip
                GestureDetector(
                    onTap: () {
                      _controller.jumpToPage(2);
                    },
                    child: Text(
                      "Skip",
                      style: TextStyle(
                        color: Colors.white,
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                      ),
                    )),

                SmoothPageIndicator(controller: _controller, count: 3),

                //next
                onLastPage
                    ? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return SignInScreen();
                              },
                            ),
                          );
                        },
                        child: Text(
                          'Done',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          _controller.nextPage(
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn,
                          );
                        },
                        child: Text(
                          'Next',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
