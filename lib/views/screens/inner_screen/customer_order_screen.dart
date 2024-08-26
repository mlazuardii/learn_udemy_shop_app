import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';

class CustomerOrderScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  double rating = 0;
  final TextEditingController _reviewController = TextEditingController();

  String formatedDate(date){
    final outputDateFormate = DateFormat("dd/MM/yyyy");
    final outputDate = outputDateFormate.format(date.toDate());

    return outputDate;
  }

  Future<bool> hasUserReviewedProduct(String productId) async {
    final user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot = await FirebaseFirestore.instance
    .collection('productReviews')
    .where('buyerId', isEqualTo: user!.uid)
    .where('productId',isEqualTo: productId)
    .get();

    return QuerySnapshot.docs.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _ordersStream = FirebaseFirestore.instance.collection('orders').where('buyerId',isEqualTo: _auth.currentUser!.uid).snapshots();

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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('order date : '+formatedDate(data['orderDate'])),
                              ),
                              data['accepted'] == true ?
                              ElevatedButton(onPressed: () {
                                showDialog(context: context, builder: (context) {
                                  return AlertDialog(
                                    title: Text('Leave a review'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextFormField(
                                          controller: _reviewController,
                                          decoration: InputDecoration(
                                            labelText: 'Your Review'
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: RatingBar.builder(
                                            initialRating: rating,
                                            itemCount: 5,
                                            minRating: 1,
                                            maxRating: 5,
                                            allowHalfRating: true,
                                            itemSize: 15,
                                            unratedColor: Colors.grey,
                                            itemPadding: EdgeInsets.symmetric(horizontal: 4),
                                            itemBuilder: (context, _) {
                                            return Icon(Icons.star,
                                            color: Colors.amber);
                                          }, onRatingUpdate: (value) {
                                            rating = value;
                                          },),
                                        )
                                      ],
                                    ),
                                    actions: [
                                      TextButton(onPressed: () async {
                                        final review = _reviewController.text;

                                        await FirebaseFirestore.instance.collection('productReviews')
                                        .doc(data['orderId'])
                                        .set(
                                          {
                                            'productId':data['productId'],
                                            'fullName': data['fullName'],
                                            'buyerId':data['buyerId'],
                                            'rating':rating,
                                            'review':review,
                                            'email':data['email']
                                          }
                                        ).whenComplete(() {
                                          Navigator.pop(context);
                                          _reviewController.clear();
                                        },);
                                      }, child: Text('Submit'))
                                    ],
                                  );
                                },);
                              }, child: Text('Review'))
                              : Text('')
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