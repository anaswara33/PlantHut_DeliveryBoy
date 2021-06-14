import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/order.dart';
import 'package:delivery/order_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NewOrder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(onTap: () => Navigator.pop(context), child: Icon(Icons.arrow_back)),
          title: Text('New Orders'),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("orders")
                .where("delivery", isNull: true)
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
                      return OrderItem(
                          order: data[index],
                          onTap: () async {
                            await showAlertDialog(context, data[index]);
                          });
                    }),
                  ),
                ),
              );
            }));
  }
}

Future<void> showAlertDialog(context, Order order) async {
  return await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Take order'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Would you like to take this order?'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Yes'),
            onPressed: () async {
              Navigator.of(context).pop();
              await bookOrder(context, order);
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

bookOrder(BuildContext context, Order order) async {
  try {
    await FirebaseFirestore.instance.collection("orders").doc(order.orderId).update({
      'delivery':
          FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser.uid)
    }).then((value) {
      Fluttertoast.showToast(msg: "Booked");
    });
  } catch (e) {
    Fluttertoast.showToast(msg: e.toString());
  }
}
