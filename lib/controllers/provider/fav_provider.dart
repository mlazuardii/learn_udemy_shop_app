import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_udemy_shop_app/models/fav_models.dart';

final favProvider = StateNotifierProvider<FavNotifier, Map<String, FavModel>>((ref) {
  return FavNotifier();
});

class FavNotifier extends StateNotifier<Map<String, FavModel>>{
  FavNotifier() : super({});

  void addProductToFav(
    String productName,
    String productId,
    List imageUrl,
    int quantity,
    int productQuantity,
    double price,
    String vendorId
  ){
    state[productId] = FavModel(productName: productName, productId: productId, imageUrl: imageUrl, quantity: quantity, productQuantity: productQuantity, price: price, vendorId: vendorId);

    // Notify listeners that the state has changed
    state = {...state};
  }

  void removeAllItems(){
    state.clear();
    // Notify listeners that the state has changed
    state = {... state};
  }

  void removeItem(String productId){
    state.remove(productId);

    state = {... state};
  }

  Map<String, FavModel> get getFavoriteItem =>state;
}