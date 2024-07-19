import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_udemy_shop_app/controllers/provider/fav_provider.dart';

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    final _favProvider = ref.read(favProvider.notifier);
    final _wishItem = ref.watch(favProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist', style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 4
        ),),
        actions: [
          IconButton(onPressed: (){
            _favProvider.removeAllItems();
          }, icon: Icon(CupertinoIcons.delete))
        ],
      ),
      body: _wishItem.isNotEmpty? ListView.builder(
        shrinkWrap: true,
        itemCount: _wishItem.length,
        itemBuilder: (centext, index){
          final wishData =  _wishItem.values.toList()[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              child: SizedBox(
                height: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 100,
                      width: 100,
                      child: Image.network(wishData.imageUrl[0]),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [Text(wishData.productName),
                      Text(wishData.price.toStringAsFixed(2)),
                      IconButton(onPressed: (){
                        _favProvider.removeItem(wishData.productId);
                      }, icon: Icon(Icons.cancel))],
                    )
                  ],
                ),
              ),
            ),
          );
        }): Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Your Wishlist is empty', style: TextStyle(
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
    );
  }
}