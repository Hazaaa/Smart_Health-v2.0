import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_v2/domain/auth/auth_service.dart';
import 'package:smart_health_v2/domain/auth/models/user.dart';
import 'package:smart_health_v2/presentation/screens/bottom_navigation_screen.dart';
import 'package:smart_health_v2/presentation/screens/login_screen.dart';

class StartWrapperScreen extends StatelessWidget {
  const StartWrapperScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
        stream: authService.user,
        builder: (context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            final User? user = snapshot.data;

            return user == null ? LoginScreen() : BottomNavigationScreen();
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
