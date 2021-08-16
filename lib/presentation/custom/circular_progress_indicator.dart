import 'package:flutter/material.dart';
import 'package:smart_health_v2/constants/constants.dart';

class UpgradedCircularProgressIndicator extends StatelessWidget {
  /// Width of indicator. [default = 25.0]
  final double? width;

  /// Height of indicator. [default = 25.0]
  final double? height;

  /// Stroke width of indicator. [default = 4.0]
  final double? strokeWidth;

  /// Color of indicator. [default = kPrimaryDarkColor]
  final Color? color;
  const UpgradedCircularProgressIndicator(
      {this.width, this.height, this.strokeWidth, this.color, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 25.0,
      height: height ?? 25.0,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(color ?? kPrimaryDarkColor),
        strokeWidth: strokeWidth ?? 4.0,
      ),
    );
  }
}
