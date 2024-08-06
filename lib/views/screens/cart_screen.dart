import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_udemy_shop_app/controllers/provider/cart_provier.dart';
import 'package:learn_udemy_shop_app/views/screens/inner_screen/checkout_screen.dart';
import 'package:learn_udemy_shop_app/views/screens/inner_screen/payment_screen.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final _cartProvider = ref.read(cartProvider.notifier);
    final cartData = ref.watch(cartProvider);
    final totalAmount = ref.read(cartProvider.notifier).calculateTotalAmount();

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart', style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          letterSpacing: 5
        ),),
        actions: [
          IconButton(onPressed: (){
            _cartProvider.removeAllItems();
          }, icon: Icon(CupertinoIcons.delete))
        ],
      ),
      body: cartData.isNotEmpty? ListView.builder(
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

                          Row(
                            children: [
                              Container(
                                height: 40,
                                width: 120,
                                decoration: BoxDecoration(
                                  color: Colors.pink,
                                  borderRadius: BorderRadius.circular(4)
                                ),
                                child: Row(
                                  children: [
                                    IconButton(onPressed: (){
                                      _cartProvider.decrementItem(cartItem.productId);
                                    }, icon: Icon(CupertinoIcons.minus, color: Colors.white,)),
                                    Text(cartItem.quantity.toString(), style: TextStyle(
                                      color: Colors.white
                                    ),),
                                    IconButton(onPressed: (){
                                      _cartProvider.incrementItem(cartItem.productId);
                                    }, icon: Icon(
                                      CupertinoIcons.plus, color: Colors.white,
                                    ))
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                              IconButton(onPressed: (){
                                _cartProvider.removeItem(cartItem.productId);
                              }, icon: Icon(
                                CupertinoIcons.delete
                              ))
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
      })): Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your Cart is empty', style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                letterSpacing: 5
              ),),
              Text('You haven\'t added any item\n you can add from the home screen', style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal
              ),
              textAlign: TextAlign.center)
            ],
          ),
        ),
        bottomNavigationBar: Container(
          height: 80,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Price'+totalAmount.toStringAsFixed(2)),
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    // return CheckoutScreen();
                    return PaymentScreen();
                  }));
                }, child: Text('Checkout', style: TextStyle(
                  fontWeight: FontWeight.bold
                ),))
              ],
            ),
          ),
        ),
    );
  }
}