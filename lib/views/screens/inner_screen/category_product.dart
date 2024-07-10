import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/get_utils.dart';

class CategoryProductScreen extends StatefulWidget {
  final dynamic categoryData;

  const CategoryProductScreen({super.key, this.categoryData});

  @override
  State<CategoryProductScreen> createState() => _CategoryProductScreenState();
}

class _CategoryProductScreenState extends State<CategoryProductScreen> {
  
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _productStream = FirebaseFirestore.instance.collection('products').where('productCategory',isEqualTo: widget.categoryData['categoryName']).snapshots();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.categoryData['categoryName'],
        style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 4),),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _productStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if(snapshot.data!.docs.isEmpty){
            return Center(
              child: Text('No product under \n this category'),
            );
          }

          return GridView.builder(
            itemCount: snapshot.data!.size,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 9, childAspectRatio: 200/300), itemBuilder: (context, index){
            final productData = snapshot.data!.docs[index];

            return Card(
              elevation: 4,
              child: Column(
                children: [
                  productData['imageUrlList'] != null ?
                  Column(
                    children: [
                      Container(
                        height: 170,
                        width: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(productData['imageUrlList'][0]))
                        )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(productData['productName']),
                      ),
                      Text('\$ '+productData['productPrice'].toStringAsFixed(2))
                    ],
                  )
                  : Text(''),
                ],
              ),
            );
          });
        },
      ),
    );
  }
}