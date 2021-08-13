import 'package:flutter/material.dart';
import 'package:smart_health_v2/presentation/screens/login_screen.dart';
import 'package:smart_health_v2/constants/size_confige.dart';
import 'package:smart_health_v2/routes/router.dart' as router;

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
      onGenerateRoute: router.generateRoute,
      home: Builder(builder: (context) {
        SizeConfig.initSize(context);
        return LoginScreen();
      }),
    );
  }
}
