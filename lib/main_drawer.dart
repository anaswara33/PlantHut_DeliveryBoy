import 'package:delivery/menu.dart';
import 'package:delivery/sharedpref_helper.dart';
import 'package:delivery/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainDrawer extends StatelessWidget {
  final Function(Menu) onItemCallback;

  const MainDrawer({Key key, this.onItemCallback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 30,
              ),
              color: Theme.of(context).primaryColor,
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 50),
                child: Center(
                    child: Text(
                  "PlantHut delivery",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                )),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onItemCallback(Menu.profile);
              },
            ),
            ListTile(
              leading: Icon(Icons.dashboard),
              title: Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onItemCallback(Menu.dashboard);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(
                'Log out',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              onTap: () {
                showAlertDialog(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showAlertDialog(context) async {
    return await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log out?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Would you like to logout?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Yes'),
              onPressed: () async {
                Navigator.of(context).pop();
                await logout(context);
              },
            ),
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logout(context) async {
    await SharedPrefHelper.clear();
    await FirebaseAuth.instance.signOut();
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (context) => SplashScreen()), (route) => false);
  }
}
