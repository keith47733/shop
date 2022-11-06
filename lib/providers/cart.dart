import 'package:flutter/material.dart';

import 'cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }

  int get numberOfCartItems {
    int numberOfCartItems = 0;
    _cartItems.forEach((key, value) {
      numberOfCartItems = numberOfCartItems + _cartItems[key]!.quantity;
    });
    return numberOfCartItems;
  }

  double get cartTotal {
    double total = 0.0;
    _cartItems.forEach((key, cartItem) {
      total = total + (cartItem.quantity * cartItem.price);
    });
    return total;
  }

  void addCartItem({
    required String productId,
    required String title,
    required double price,
  }) {
    if (_cartItems.containsKey(productId)) {
      _cartItems.update(
        productId,
        (existingCartItem) => CartItem(
          cartItemId: existingCartItem.cartItemId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _cartItems.putIfAbsent(
        productId,
        () => CartItem(
          cartItemId: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeCartItem(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _cartItems = {};
    notifyListeners();
  }
}
