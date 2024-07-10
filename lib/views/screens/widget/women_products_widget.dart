import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:learn_udemy_shop_app/views/screens/widget/product_model.dart';

class WomenProductsWidget extends StatelessWidget {
  const WomenProductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance.collection('products').where("productCategory", isEqualTo: "Women").snapshots();


    return StreamBuilder<QuerySnapshot>(
      stream: _productStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text('No products'),
          );
        }

        return Container(
          height: 100,
          child: PageView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: ((context, index) {
              final productData = snapshot.data!.docs[index];

              return ProductModel(productData: productData);
            }
          )),
        );
      },
    );
  }
}