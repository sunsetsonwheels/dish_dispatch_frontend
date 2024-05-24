import 'package:dish_dispatch/models/cart.dart';
import 'package:dish_dispatch/models/restaurant.dart';
import 'package:flutter/foundation.dart';

class CartProvider extends ChangeNotifier {
  Map<BaseRestaurant, Map<String, CartItem>> cart = {};
  double get total {
    double t = 0;
    for (final v1 in cart.values) {
      for (final cartItem in v1.values) {
        t += cartItem.price * cartItem.quantity;
      }
    }
    return t;
  }

  void add({
    required BaseRestaurant restaurant,
    required String item,
    required double price,
    required int quantity,
  }) {
    if (!cart.containsKey(restaurant)) {
      cart[restaurant] = {};
    }
    cart[restaurant]?[item] = CartItem(price: price, quantity: quantity);
    notifyListeners();
  }

  void decrease({
    required BaseRestaurant restaurant,
    required String item,
  }) {
    cart[restaurant]?[item]?.quantity--;
    notifyListeners();
  }

  void increase({
    required BaseRestaurant restaurant,
    required String item,
  }) {
    cart[restaurant]?[item]?.quantity++;
    notifyListeners();
  }

  void deleteMenuItem({
    required BaseRestaurant restaurant,
    required String item,
  }) {
    cart[restaurant]?.remove(item);
    if (cart[restaurant]?.isEmpty ?? false) {
      cart.remove(restaurant);
    }
    notifyListeners();
  }

  void clear() {
    cart = {};
    notifyListeners();
  }
}
