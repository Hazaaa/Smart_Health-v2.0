import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:smart_health_v2/constants/constants.dart';

class SmartHealthLogo extends StatelessWidget {
  const SmartHealthLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GradientText(
          'SMART',
          gradient: LinearGradient(
            colors: [
              kPrimarylightColor,
              kPrimaryDarkColor,
            ],
          ),
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
        GradientText(
          'HEALTH',
          gradient: LinearGradient(
            colors: [
              kPrimaryDarkColor,
              kPrimarylightColor,
            ],
          ),
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
