import 'package:flutter/material.dart';
import 'package:smart_health_v2/presentation/screens/bottom_navigation_screen.dart';

class ScreenTitle extends StatelessWidget {
  final String titleText;
  final IconData? icon;
  final String? heroTag;
  final bool? backArrow;
  final int? backSelectedIndex;

  const ScreenTitle(
      {required this.titleText,
      this.icon,
      this.heroTag,
      this.backArrow,
      this.backSelectedIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: backArrow != null,
            child: Container(
              margin: EdgeInsets.only(right: 15.0, left: 10.0),
              child: GestureDetector(
                child: Icon(Icons.arrow_back_ios_rounded),
                onTap: () {
                  if (backSelectedIndex != null) {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BottomNavigationScreen(
                                selectedIndex: this.backSelectedIndex!)));
                  } else {
                    Navigator.pop(context);
                  }
                },
              ),
            ),
          ),
          Visibility(
              visible: icon != null,
              child: Container(
                  margin: EdgeInsets.only(bottom: 1.0), child: Icon(icon))),
          Flexible(
            child: Container(
                margin: EdgeInsets.only(left: 5.0, right: 40.0),
                child: heroTag != null
                    ? Hero(tag: heroTag!, child: _buildTitleText(titleText))
                    : _buildTitleText(titleText)),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleText(String titleText) {
    return Text(
      titleText,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
    );
  }
}
