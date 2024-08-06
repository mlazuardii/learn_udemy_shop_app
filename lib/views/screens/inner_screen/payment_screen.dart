import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:learn_udemy_shop_app/views/screens/inner_screen/checkout_screen.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  bool isPayOnDelivery = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Options'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text('Select payment method', style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87
            ),),
            Row(
              children: [
                Text('Pay On Delivery', style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w300
                ),),
                Switch(value: isPayOnDelivery, onChanged: (value){
                  setState(() {
                    isPayOnDelivery = value;
                  });

                  if(isPayOnDelivery){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return CheckoutScreen();
                    }));
                  }
                })
              ],
            )
          ],
        ),
      ),
    );
  }
}