import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/order.dart';
import 'package:delivery/order_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeliveredOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back)),
          title: Text('Delivered Orders'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("orders")
                .where("delivery",
                    isEqualTo: FirebaseFirestore.instance
                        .collection("users")
                        .doc(FirebaseAuth.instance.currentUser.uid))
                .orderBy("date", descending: true)
                .snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }

              final data = snapshot.data.docs.map((e) => Order.fromDoc(e)).toList();
              print(snapshot.data.docs.toString());
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Wrap(
                    runSpacing: 10,
                    spacing: 10,
                    children: List.generate(data.length, (index) {
                      return OrderItem(order: data[index]);
                    }),
                  ),
                ),
              );
            }));
  }
}
