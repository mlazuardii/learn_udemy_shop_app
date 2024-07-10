import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_udemy_shop_app/controllers/provider/cart_provier.dart';

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  @override
  Widget build(BuildContext context) {
    final cartData = ref.watch(cartProvider);

    return ListView.builder(
      shrinkWrap:true,
      itemCount: cartData.length,
      itemBuilder: ((context, index) {
        final cartItem =cartData.values.toList()[index];
    
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(cartItem.productName),
            Text(cartItem.quantity.toString()),
          ],
        );
    }));
  }
}