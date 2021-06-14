import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/info_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  const Profile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data.data();
            return SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "${data['fname']} ${data['lname']}",
                    style: TextStyle(
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Pacifico",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: Text(
                            "ID: ${snapshot.data.id}",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.blueGrey[200],
                                letterSpacing: 2.5,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Source Sans Pro"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 20,
                    width: 200,
                    child: Divider(
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InfoCard(text: data['phone'], icon: Icons.phone, onPressed: () async {}),
                  InfoCard(text: data['address'], icon: Icons.location_city, onPressed: () async {}),
                  InfoCard(text: data['email'], icon: Icons.email, onPressed: () async {}),
                ],
              ),
            );
          }

          return Center(child: CircularProgressIndicator());
        });
  }
}
