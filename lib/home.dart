import 'package:delivery/dashboard_screen.dart';
import 'package:delivery/main_drawer.dart';
import 'package:delivery/menu.dart';
import 'package:delivery/profile.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Menu currentMenu = Menu.profile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[800],
        appBar: AppBar(
          title: Text(currentMenu.toStringValue().toUpperCase()),
        ),
        drawer: MainDrawer(onItemCallback: onItemCallback),
        body: SafeArea(
          child: Container(child: getBody()),
        ));
  }

  getBody() {
    if (currentMenu == Menu.profile) {
      return Profile();
    } else {
      return Dashboard();
    }
  }

  onItemCallback(Menu menu) {
    setState(() {
      currentMenu = menu;
    });
  }
}
