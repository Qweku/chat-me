// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final Function()? onTap;
  final String buttonText;
  final Color color;
  final Color textColor;
  final double? width;
  final Color borderColor;
  final bool buttonShadow;
  final double radius, verticalPadding;
  const Button({
    Key? key,
    this.onTap,
    required this.buttonText,
    this.color = Colors.transparent,
    this.width,
    this.borderColor = Colors.transparent,
    this.buttonShadow = true,
    this.textColor = Colors.white,
    this.radius = 10,
    this.verticalPadding = 18,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Card(
          elevation: buttonShadow ? 3 : 0,
          color: color,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius),
              side: BorderSide(color: borderColor)),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: verticalPadding),
            child: Text(
              buttonText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
