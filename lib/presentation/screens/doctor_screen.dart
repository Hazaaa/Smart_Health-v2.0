import 'package:flutter/material.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/presentation/specific/banner.dart';
import 'package:smart_health_v2/presentation/specific/doctors_list.dart';
import 'package:smart_health_v2/presentation/common/search_field.dart';
import 'package:smart_health_v2/constants/size_confige.dart';
import '../custom/appbar.dart';
import '../specific/categories_list.dart';

class DoctorScreen extends StatefulWidget {
  @override
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: _buildDoctorScreen(context),
    );
  }

  Widget _buildDoctorScreen(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: getRelativeHeight(0.015)),
            DoctorAppBar(),
            SizedBox(height: getRelativeHeight(0.015)),
            DoctorBanner(),
            SizedBox(height: getRelativeHeight(0.012)),
            SearchField(),
            SizedBox(height: getRelativeHeight(0.025)),
            CategoriesList(),
            SizedBox(height: getRelativeHeight(0.01)),
            DoctorsList()
          ],
        ),
      ),
    );
  }
}
