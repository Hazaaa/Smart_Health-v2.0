import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_v2/domain/auth/auth_service.dart';
import 'package:smart_health_v2/constants/size_confige.dart';
import 'package:smart_health_v2/domain/data/database.dart';
import 'package:smart_health_v2/domain/location/location_service.dart';
import 'package:smart_health_v2/presentation/screens/bottom_navigation_screen.dart';
import 'package:smart_health_v2/presentation/screens/login_screen.dart';
import 'package:smart_health_v2/routes/router.dart' as router;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(),
        ),
        Provider<Database>(create: (_) => Database()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Health',
        theme: ThemeData(
          fontFamily: "Nunito",
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: router.generateRoute,
        home: Builder(builder: (context) {
          auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
          SizeConfig.initSize(context);
          return firebaseUser == null
              ? LoginScreen()
              : BottomNavigationScreen();
        }),
      ),
    );
  }
}
