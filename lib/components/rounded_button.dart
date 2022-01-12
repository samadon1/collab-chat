import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  RoundedButton(
      {required this.title, required this.colour, required this.onPressed});

  late final String title;
  late final Color colour;
  late final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 25.0),
      child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(colour),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                // side: BorderSide(color: Colors.white)
              ),
            ),
          ),
          onPressed: onPressed,
          child: Container(
            width: 270,
            height: 45,
            child: Center(child: Text(title)),
          )),
    );
  }
}
