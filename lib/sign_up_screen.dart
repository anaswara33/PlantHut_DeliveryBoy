import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/home.dart';
import 'package:delivery/sharedpref_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String email;
  String password;
  String fname;
  String lname;
  String phone;
  String address;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Form(
        key: _formkey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.fromLTRB(15.0, 110.0, 0.0, 0.0),
                    child: Text('Hello\nThere',
                        style: TextStyle(
                            fontSize: 80.0, fontWeight: FontWeight.bold)),
                  ),
                  Container(
                    child: Text('.',
                        style: TextStyle(
                            fontSize: 80.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.green)),
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
                          return 'please type an email';
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
                    SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'please type first name';
                        }
                        return null;
                      },
                      onSaved: (value) => fname = value,
                      decoration: InputDecoration(
                          labelText: 'First Name',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.name,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'please type last name';
                        }
                        return null;
                      },
                      onSaved: (value) => lname = value,
                      decoration: InputDecoration(
                          labelText: 'Last Name',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.phone,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'please type phone';
                        }
                        return null;
                      },
                      onSaved: (value) => phone = value,
                      decoration: InputDecoration(
                          labelText: 'Phone',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.streetAddress,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'please type address';
                        }
                        return null;
                      },
                      onSaved: (value) => address = value,
                      decoration: InputDecoration(
                          labelText: 'Address',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      validator: (input) {
                        if (input.isEmpty) {
                          return 'please type a password';
                        }
                        return null;
                      },
                      onSaved: (value) => password = value,
                      decoration: InputDecoration(
                          labelText: 'PASSWORD',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                      obscureText: true,
                    ),
                    SizedBox(height: 40.0),
                    Container(
                      height: 40.0,
                      child: Material(
                        borderRadius: BorderRadius.circular(20.0),
                        shadowColor: Colors.greenAccent,
                        color: Colors.green,
                        elevation: 7.0,
                        child: InkWell(
                          onTap: () async {
                            if (_formkey.currentState.validate()) {
                              _formkey.currentState.save();
                              await signup(context);
                            }
                          },
                          child: Center(
                            child: Text(
                              'SIGN UP',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                    InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        height: 40.0,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 1.0),
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(20.0)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(width: 10.0),
                              Center(
                                child: Text('GO BACK',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'Montserrat')),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.0),
                  ],
                ))
          ],
        ),
      ),
    ));
  }

  Future<void> signup(BuildContext context) async {
    final progress = ProgressDialog(context);
    try {
      progress.show();
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((user) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(user.user.uid)
            .set({
          'email': user.user.email,
          'type': "Delivery",
          'fname': fname,
          'lname': lname,
          'phone': phone,
          'address': address
        }).then((value) async {
          await SharedPrefHelper.setUserId(user.user.uid);
          progress.hide();
          Navigator.pushAndRemoveUntil(
              context,
              new MaterialPageRoute(builder: (context) => Home()),
              (route) => false);
        });
      });
    } on FirebaseAuthException catch (e) {
      progress.hide();
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.');
      }
    } catch (e) {
      progress.hide();
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
