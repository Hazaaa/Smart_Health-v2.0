import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:smart_health_v2/constants/constants.dart';
import 'package:smart_health_v2/presentation/common/logo.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        body: SafeArea(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              SmartHealthLogo(),
              Container(
                margin: EdgeInsets.only(top: 30),
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // HEALTH CARD NUMBER
                    Container(
                      margin: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: TextFormField(
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

                    // PASSWORD
                    Container(
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: TextFormField(
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

                    // SUBMIT BUTTON
                    Container(
                      margin: EdgeInsets.only(left: 50, right: 50),
                      child: GradientButton(
                          child: Text("Prijavi se"),
                          increaseHeightBy: 10,
                          increaseWidthBy: 10,
                          gradient: LinearGradient(
                            colors: [
                              kPrimarylightColor,
                              kPrimaryDarkColor,
                            ],
                          ),
                          callback: () {
                            if (_formKey.currentState.validate()) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Podaci se proveravaju...')),
                              );
                            }
                          }),
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
