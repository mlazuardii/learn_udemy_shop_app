import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:learn_udemy_shop_app/views/screens/auth/login_screen.dart';
import 'package:learn_udemy_shop_app/views/screens/inner_screen/customer_order_screen.dart';

class AccountScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    CollectionReference buyers = FirebaseFirestore.instance.collection('buyers');

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Proile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 4
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(
              Icons.sunny_snowing,
              color: Colors.pink,
            ),
          )
        ],
      ),
      body: 
        FutureBuilder<DocumentSnapshot>(
        future: buyers.doc(_auth.currentUser!.uid).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

          if (snapshot.hasError) {
            return Text("Something went wrong");
          }

          if (snapshot.hasData && !snapshot.data!.exists) {
            return Text("Document does not exist");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            return Center(
              child: Column(
                children: [
                  SizedBox(height: 15),
                  CircleAvatar(
                    radius: 65,
                    backgroundImage: NetworkImage(data['profileImage']),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data['fullName'].toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 5
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      data['email'],
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4
                      ),
                    ),
                  ),
                  // Container(
                  //   height: 40,
                  //   width: MediaQuery.of(context).size.width - 80,
                  //   decoration: BoxDecoration(
                  //     color: Colors.pink
                  //   ),
                  // )
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width - 80,
                      child: 
                        ElevatedButton(
                          onPressed: (){},
                          child: Text('Edit Profile')
                          )
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Divider(
                      thickness: 2,
                      color: Colors.grey,
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text(
                      'Settings',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(CupertinoIcons.shopping_cart),
                    title: Text(
                      'Cart',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return CustomerOrderScreen();
                      }));
                    },
                    leading: Icon(CupertinoIcons.bag),
                    title: Text(
                      'Orders',
                      style: TextStyle(
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  ListTile(
                    onTap: () async {
                      await _auth.signOut().whenComplete((){
                        return Navigator.pushReplacement(context, 
                        MaterialPageRoute(builder: (context){
                          return CustomerLoginScreen();
                        }));
                      });
                    },
                    leading: Icon(Icons.logout),
                    title: Text(
                      'Logout',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.pink
                      ),
                    ),
                  )
                ],
              ),
            );
          }

          return Center(child: CircularProgressIndicator(),);
        },
      )
    );
  }
}