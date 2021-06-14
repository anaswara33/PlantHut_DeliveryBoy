import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:delivery/order.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OrderItem extends StatelessWidget {
  final Order order;
  final AsyncCallback onTap;

  const OrderItem({Key key, this.order, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: FutureBuilder<DocumentSnapshot>(
          future: order.uid.get(),
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.hasData && !snapshot.data.exists) {
              return Text("Document does not exist");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();
              return Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFFF5F6F9),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Order ID : ${order.orderId}",
                      style:
                          TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
                      maxLines: 2,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Total amount: ${order.total}",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      maxLines: 2,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Address: ${data['address']}",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      maxLines: 2,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Recipient name: ${data['fname']}",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      maxLines: 2,
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Order date: ${DateFormat.yMd().format(order.date)}",
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      maxLines: 2,
                    ),
                    SizedBox(height: 10),
                    Text(
                      getItems(order.items),
                      style: TextStyle(color: Colors.black, fontSize: 16),
                      maxLines: 2,
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }

  String getItems(List<Item> items) {
    String string = "Items:\n";
    items.forEach((element) {
      string = string + ". ${element.pName} x${element.quantity}\n";
    });
    return string;
  }
}
