import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CustomerOrderScreen extends StatelessWidget {
  const CustomerOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance.collection('orders').snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text('Order'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _ordersStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading");
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 14,
                      child: data['accepted'] == true?
                      Icon(Icons.delivery_dining)
                      : Icon(Icons.access_time),
                    ),
                  
                    title: data['accepted'] == true?
                    Text('Accepted')
                    : Text('Pending'),
                  
                    trailing: Text(data['price'].toStringAsFixed(2)),
                  ),
                  ExpansionTile(
                    title: Text('Order Details'),
                    subtitle: Text('View order details'),
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          child: Image.network(data['productImage'][0]),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(data['productName']),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text('Quantity'),
                                Text(data['quantity'].toString()),
                              ],
                            )
                          ],
                        ),

                        subtitle: ListTile(
                          title: Text('Buyer Detail'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(data['fullName']),
                              Text(data['email']),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ],
              );
            }).toList(),
          );
        },
      ),
    );
  }
}