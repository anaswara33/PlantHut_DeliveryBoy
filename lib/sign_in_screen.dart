import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/forgotpassword_screen.dart';
import 'package:delivery/home.dart';
import 'package:delivery/sharedpref_helper.dart';
import 'package:delivery/sign_up_screen.dart';
import 'package:delivery/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Signin extends StatefulWidget {
  static String routeName = "/signin";

  @override
  _SigninState createState() => new _SigninState();
}

class _SigninState extends State<Signin> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String email;
  String password;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formkey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                          child: Text(
                            'Sign In',
                            style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          child: Text(
                            '.',
                            style: TextStyle(
                                fontSize: 80.0, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                      padding: EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                      child: Column(
                        children: <Widget>[
                          TextFormField(
                            keyboardType: TextInputType.emailAddress,
                            validator: (input) {
                              if (input.isEmpty) {
                                return 'Please type an email';
                              }
                              return null;
                            },
                            onSaved: (value) => email = value,
                            decoration: InputDecoration(
                                labelText: 'EMAIL',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green))),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            validator: (input) {
                              if (input.length < 6) {
                                return 'Your password needs to be atleast 6 characters';
                              }
                              return null;
                            },
                            onSaved: (value) => password = value,
                            decoration: InputDecoration(
                                labelText: 'PASSWORD ',
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.green))),
                            obscureText: true,
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            alignment: Alignment(1.0, 0.0),
                            padding: EdgeInsets.only(top: 15.0, left: 20.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    new MaterialPageRoute(builder: (context) => Forgotpassword()));
                              },
                              child: Text(
                                'Forgot Password',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    decoration: TextDecoration.underline),
                              ),
                            ),
                          ),
                          SizedBox(height: 50.0),
                          Container(
                              height: 40.0,
                              child: Material(
                                borderRadius: BorderRadius.circular(20.0),
                                shadowColor: Colors.greenAccent,
                                color: Colors.green,
                                elevation: 7.0,
                                // ignore: deprecated_member_use
                                child: InkWell(
                                  onTap: () async {
                                    if (_formkey.currentState.validate()) {
                                      _formkey.currentState.save();
                                      await login(context);
                                    }
                                  },
                                  child: Center(
                                    child: Text(
                                      'Sign In',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Montserrat'),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      )),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context, new MaterialPageRoute(builder: (context) => Signup()));
                        },
                        child: Text(
                          'New to Here ? Sign up',
                          style: TextStyle(fontFamily: 'Montserrat', color: Colors.green),
                        ),
                      ),
                      SizedBox(width: 5.0),
                    ],
                  ),
                ],
              ),
            )));
  }

  Future<void> login(BuildContext context) async {
    final progress = ProgressDialog(context);
    try {
      progress.show();
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(value.user.uid)
            .get()
            .then((user) async {
          final UserModel currentUser = UserModel.fromDoc(user);
          if (currentUser.type != "Delivery") {
            progress.hide();
            Fluttertoast.showToast(msg: "No user found for that email");
          } else {
            await SharedPrefHelper.setUserId(value.user.uid);
            progress.hide();
            Navigator.pushAndRemoveUntil(
                context, new MaterialPageRoute(builder: (context) => Home()), (route) => false);
          }
        });
      });
    } on FirebaseAuthException catch (e) {
      progress.hide();
      if (e.code == 'user-not-found') {
        Fluttertoast.showToast(msg: "No user found for that email");
      } else if (e.code == 'wrong-password') {
        Fluttertoast.showToast(msg: "Wrong password");
      }
    } catch (e) {
      progress.hide();
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
