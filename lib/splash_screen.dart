import 'package:delivery/home.dart';
import 'package:delivery/sharedpref_helper.dart';
import 'package:delivery/sign_in_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkLogin();
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'PLANTHUT - Delivery App',
            style:
                TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
          )
        ],
      ),
    ));
  }

  void checkLogin() async {
    if (await SharedPrefHelper.getUserId() != null && FirebaseAuth.instance.currentUser != null) {
      Navigator.pushAndRemoveUntil(
          context, new MaterialPageRoute(builder: (context) => Home()), (route) => false);
    } else {
      Navigator.pushAndRemoveUntil(
          context, new MaterialPageRoute(builder: (context) => Signin()), (route) => false);
    }
  }
}
