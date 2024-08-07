import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_udemy_shop_app/controllers/provider/cart_provier.dart';
import 'package:uuid/uuid.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final _cartProvider = ref.read(cartProvider.notifier);
    final cartData = ref.watch(cartProvider);
    final totalAmount = ref.read(cartProvider.notifier).calculateTotalAmount();
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
      ),
      body: ListView.builder(
        shrinkWrap:true,
        itemCount: cartData.length,
        itemBuilder: ((context, index) {
          final cartItem =cartData.values.toList()[index];
      
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: SizedBox(
                height: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.network(cartItem.imageUrl[0], fit: BoxFit.contain,),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cartItem.productName, style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold
                          ),),

                          Text(cartItem.price.toStringAsFixed(2), style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.pink
                          ),),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
      })),

      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextButton(onPressed: (){
          
        }, child: InkWell(
          onTap: () async {
            setState(() {
              _isLoading = true;
            });
            DocumentSnapshot userDoc = await _firestore.collection('buyers').doc(_auth.currentUser!.uid).get();

            _cartProvider.getCartItem.forEach((key, item) async {
              final orderId = Uuid().v4();
              await _firestore.collection('orders').doc(orderId).set({
                'orderId':orderId,
                'productId':item.productId,
                'productName':item.productName,
                'quantity':item.quantity,
                'price':item.quantity*item.price,
                'fullName':(userDoc.data() as Map<String, dynamic>)['fullName'],
                'email':(userDoc.data() as Map<String, dynamic>)['email'],
                'profileImage':(userDoc.data() as Map<String, dynamic>)['profileImage'],
                'buyerId':_auth.currentUser!.uid,
                'productSize': item.productSize,
                'productImage': item.imageUrl,
                'vendorQuantity': item.productQuantity,
                'accepted':false,
                'orderDate':DateTime.now()
              }).whenComplete(() {
                setState(() {
                  _isLoading = false;
                });
              });
            });
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width - 50,
            decoration: BoxDecoration(
              color: Colors.pink,
              borderRadius: BorderRadius.circular(9)
            ),
            child: _isLoading? CircularProgressIndicator(color: Colors.white,)
            : Center(
              child: Text('Place Order' + " "+ totalAmount.toStringAsFixed(2))
            ),
          ),
        )),
      ),
    );
  }
}