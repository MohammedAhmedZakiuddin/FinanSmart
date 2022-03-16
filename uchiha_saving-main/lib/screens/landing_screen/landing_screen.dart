import 'package:flutter/material.dart';
import 'package:uchiha_saving/api/auth.dart';
import 'package:uchiha_saving/api/auth_base.dart';
import 'package:uchiha_saving/models/person.dart';
import 'package:uchiha_saving/screens/auth_screen/auth_screeen.dart';
import 'package:uchiha_saving/screens/home_screen/home_screen.dart';

// ignore: must_be_immutable
class LandingScreen extends StatelessWidget {
  LandingScreen({Key? key}) : super(key: key);

  AuthBase _auth = Auth();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Person?>(
      stream: _auth.stream,
      builder: (ctx, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return AuthScreen(key: key);
        } else {
          return HomeScreen(person: snapshot.data!, key: key);
        }
      },
    );
  }
}
