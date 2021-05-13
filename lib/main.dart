import 'package:flutter/material.dart';
import 'package:smart_health_v2/presentation/doctor_screen.dart';
import 'package:smart_health_v2/size_confige.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Health',
      theme: ThemeData(
        fontFamily: "Nunito",
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Builder(builder: (context) {
        SizeConfig.initSize(context);
        return DoctorScreen();
      }),
    );
  }
}
