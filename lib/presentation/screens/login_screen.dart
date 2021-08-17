import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:provider/provider.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/constants/size_confige.dart';
import 'package:smart_health_v2/domain/auth/auth_service.dart';
import 'package:smart_health_v2/domain/auth/models/health_card.dart';
import 'package:smart_health_v2/presentation/common/error_text.dart';
import 'package:smart_health_v2/presentation/common/logo.dart';
import 'package:smart_health_v2/presentation/custom/circular_progress_indicator.dart';
import 'package:smart_health_v2/routes/routes_constants.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController cardNumberController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    // ignore: unused_local_variable
    final authService = Provider.of<AuthService>(context, listen: false);

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SafeArea(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SmartHealthLogo(),
              SizedBox(height: getRelativeHeight(0.06)),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // HEALTH CARD NUMBER
                    Container(
                      margin: EdgeInsets.only(left: 20.0, right: 20.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: TextFormField(
                        controller: cardNumberController,
                        textAlign: TextAlign.center,
                        enableSuggestions: true,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Broj zdravstvene knjižice je obavezan!';
                          } else if (value.toString().length != 11) {
                            return 'Broj zdravstvene knjižice sadrzi 11 cifara!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.credit_card,
                            color: Colors.grey,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.only(
                              left: 15, bottom: 11, top: 11, right: 15),
                          labelText: "Broj zdravstvene knjižice",
                          labelStyle: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ),

                    SizedBox(height: getRelativeHeight(0.03)),
                    // PASSWORD
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        textAlign: TextAlign.center,
                        enableSuggestions: true,
                        obscureText: true,
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Šifra je obavezna!';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.vpn_key_rounded,
                              color: Colors.grey,
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(
                                left: 15, bottom: 11, top: 11, right: 15),
                            labelText: "Šifra",
                            labelStyle: TextStyle(color: Colors.grey)),
                      ),
                    ),

                    SizedBox(height: getRelativeHeight(0.03)),
                    // SUBMIT BUTTON
                    Container(
                      margin: EdgeInsets.only(left: 50, right: 50),
                      child: Consumer<AuthService>(
                          builder: (context, authService, snapshot) {
                        return GradientButton(
                            isEnabled: !authService.isSigningInProgress,
                            child: authService.isSigningInProgress
                                ? UpgradedCircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                : Text("Prijavi se"),
                            increaseHeightBy: 10,
                            increaseWidthBy: 10,
                            gradient: LinearGradient(
                              colors: [
                                kPrimarylightColor,
                                kPrimaryDarkColor,
                              ],
                            ),
                            callback: () {
                              if (_formKey.currentState!.validate()) {
                                FocusManager.instance.primaryFocus?.unfocus();
                                String cardNumber = cardNumberController.text;
                                String password = passwordController.text;

                                authService
                                    .signInWithCardNumberAndPassword(
                                        HealthCard(cardNumber, password))
                                    .then((value) =>
                                        Navigator.pushReplacementNamed(
                                            context, HomeRoute));
                              }
                            });
                      }),
                    ),

                    SizedBox(height: getRelativeHeight(0.03)),
                    // ERROR Messages
                    Consumer<AuthService>(
                      builder: (context, authService, child) {
                        return Visibility(
                            visible: authService.errorMessage != '',
                            child: ErrorText('${authService.errorMessage}'));
                      },
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
