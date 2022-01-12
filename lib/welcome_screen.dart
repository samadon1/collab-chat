import 'dart:ui';

import 'package:collab_chat/login_screen.dart';
import 'package:collab_chat/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'components/rounded_button.dart';

class Welcome_Screen extends StatefulWidget {
  const Welcome_Screen({Key? key}) : super(key: key);

  static const String id = "welcome";

  @override
  _Welcome_ScreenState createState() => _Welcome_ScreenState();
}

//Adding Animation

class _Welcome_ScreenState extends State<Welcome_Screen>
    with TickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  late Animation textColor;

  @override
  void initState() {
    // set controller parameters
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 3));

    // Add colortween animation
    animation =
        ColorTween(begin: Colors.grey, end: Colors.white).animate(controller);

    textColor = TextStyleTween(
      begin: TextStyle(
        color: Colors.white,
        fontSize: 40,
        fontWeight: FontWeight.bold,
      ),
      end: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 40,
        color: Colors.black54,
      ),
    ).animate(controller);

    //direction for the animation i.e 0-1
    controller.forward();

    // loop through animation
    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });

    // textColor.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });

    // see what the controller is doing
    controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  //Dispose controller when the animation screen is exited
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 50.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Hero(
                      tag: "logo",
                      child: Image.asset(
                        "images/logo.png",
                        scale: 8,
                      ),
                    ),
                    AnimatedTextKit(
                      animatedTexts: [
                        TypewriterAnimatedText(
                          'Collab Chat',
                          textStyle: textColor.value,
                          speed: const Duration(milliseconds: 200),
                        ),
                      ],
                      onTap: () {
                        print("Tap Event");
                      },
                    ),
                  ],
                ),
              ),
              RoundedButton(
                title: "Log In",
                colour: Colors.orange,
                onPressed: () {
                  Navigator.pushNamed(context, Login_Screen.id);
                },
              ),
              RoundedButton(
                title: "Register",
                colour: Colors.orangeAccent,
                onPressed: () {
                  Navigator.pushNamed(context, Register_Screen.id);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
