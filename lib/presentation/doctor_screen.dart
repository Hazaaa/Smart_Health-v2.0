import 'package:flutter/material.dart';
import 'package:smart_health_v2/constants.dart';
import 'package:smart_health_v2/presentation/banner.dart';
import 'package:smart_health_v2/presentation/bottom_navigation_bar.dart';
import 'package:smart_health_v2/presentation/doctors_list.dart';
import 'package:smart_health_v2/presentation/search_field.dart';
import 'package:smart_health_v2/size_confige.dart';
import 'appbar.dart';
import 'categories_list.dart';

class DoctorScreen extends StatefulWidget {
  @override
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: getRelativeHeight(0.025)),
              DoctorAppBar(),
              SizedBox(height: getRelativeHeight(0.015)),
              DoctorBanner(),
              SizedBox(height: getRelativeHeight(0.005)),
              SearchField(),
              SizedBox(height: getRelativeHeight(0.025)),
              CategoriesList(),
              SizedBox(height: getRelativeHeight(0.01)),
              DoctorsList()
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(
        selectedIndex: _selectedIndex,
        onItemPressed: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        centerIcon: Icons.place,
        itemIcons: [
          Icons.home,
          Icons.notifications,
          Icons.message,
          Icons.account_box,
        ],
      ),
    );
  }
}
