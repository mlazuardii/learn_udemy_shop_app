import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_udemy_shop_app/controllers/provider/cart_provier.dart';
import 'package:learn_udemy_shop_app/controllers/provider/selected_size_provider.dart';
import 'package:learn_udemy_shop_app/views/screens/inner_screen/chat_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  final dynamic productData;

  const ProductDetailScreen({super.key, required this.productData});

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _imageIndex = 0;

  void callVendor(String phoneNumber) async {
    final Uri url = Uri(scheme: 'tel', path: phoneNumber);

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }else{
      throw('Could not launch phone call');
    }

  }
  @override
  Widget build(BuildContext context) {
    final selectedSize = ref.watch(selectedSizeNotifier);
    final _cartProvider = ref.read(cartProvider.notifier);
    final cartItem = ref.watch(cartProvider);
    final isInCart = cartItem.containsKey(widget.productData['productId']);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.productData['productName']),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Image.network(widget.productData['imageUrlList'][_imageIndex], fit: BoxFit.cover,),
                  ),
                ),
            
                Positioned(
                  bottom: 0,
                  child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.productData['imageUrlList'].length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _imageIndex = index;
                            });
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.pink.shade900
                              )
                            ),
                            child: Image.network(widget.productData['imageUrlList'][index]),
                          ),
                        ),
                      );
                  }),
                ))
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(widget.productData['productName'], style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4
                  ),),
                  SizedBox(
                    height: 20,
                  ),
                  Text('\$'+widget.productData['productPrice'].toString(), style: TextStyle(
                    fontSize: 20
                  ),),
                ],
              ),
            ),

            SizedBox(
              height: 10,
            ),

            ExpansionTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                    Text('Product Description'),
                    Text('View More', style: TextStyle(
                      color: Colors.pink
                    ),),
                ],
              ),
              children: [
                Text(widget.productData['description'])
              ],
            ),

            SizedBox(
              height: 10,
            ),

            ExpansionTile(
              title: Text('Product Variation'),
              children: [
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.productData['sizeList'].length,
                    itemBuilder: (context, index){
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(onPressed: (){
                          final newSelectedSize = widget.productData['sizeList'][index];

                          ref
                          .read(selectedSizeNotifier.notifier)
                          .setSelectedSize(newSelectedSize);
                        }, child: Text(widget.productData['sizeList'][index])),
                      );
                    }
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              leading: CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(widget.productData['storeImageUrl']),
              ),
              title: Text(widget.productData['businessName'], style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold
              ),),
              subtitle: Text('See Profile', style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.pink
              ),),
            )
          ],
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: isInCart? null : () {
                _cartProvider.addProductToCart(widget.productData['productName'], widget.productData['productId'], widget.productData['imageUrlList'], 1, widget.productData['productQuantity'], widget.productData['productPrice'], widget.productData['vendorId'], selectedSize);

                print(_cartProvider.getCartItem.values.first.productName);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: isInCart? Colors.grey : Colors.pink.shade900,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(CupertinoIcons.shopping_cart, color: Colors.white,),
                      Text(isInCart? 'In Cart' : 'Add to cart', style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 5
                      ),)
                    ],
                  ),
                ),
              ),
            ),
            IconButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context){
                return ChatScreen(
                  sellerId: widget.productData['vendorId'],
                  buyerId: FirebaseAuth.instance.currentUser!.uid,
                  productId: widget.productData['productId'],
                  productName: widget.productData['productName'],
                );
              }));
            }, icon: Icon(CupertinoIcons.chat_bubble,
            color: Colors.pink,)),
            IconButton(onPressed: (){
              callVendor("+123");
            }, icon: Icon(CupertinoIcons.phone,
            color: Colors.pink,))
          ],

        ),
      ),
    );
  }
}