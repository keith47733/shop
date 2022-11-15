import 'package:flutter/material.dart';

import 'cart_item.dart';

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartProducts = {};

  Map<String, CartItem> get cartItems {
    return {..._cartProducts};
  }

  int get numberOfCartItems {
    int numberOfCartItems = 0;
    _cartProducts.forEach((key, value) {
      numberOfCartItems = numberOfCartItems + _cartProducts[key]!.quantity;
    });
    return numberOfCartItems;
  }

  double get cartTotal {
    double total = 0.0;
    _cartProducts.forEach((key, cartItem) {
      total = total + (cartItem.quantity * cartItem.price);
    });
    return total;
  }

  void addCartItem(
    String productId,
    String title,
    double price,
  ) {
    if (_cartProducts.containsKey(productId)) {
      _cartProducts.update(
        productId,
        (existingCartItem) => CartItem(
          cartItemId: existingCartItem.cartItemId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _cartProducts.putIfAbsent(
        productId,
        () => CartItem(
          cartItemId: DateTime.now().toString(),
          quantity: 1,
          title: title,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    _cartProducts.remove(productId);
    notifyListeners();
  }

  void removeItem(String productId) {
    if (!_cartProducts.containsKey(productId)) {
      return;
    }
    if (_cartProducts[productId]!.quantity > 1) {
      _cartProducts.update(
        productId,
        (_existingCartItem) => CartItem(
          cartItemId: _existingCartItem.cartItemId,
          title: _existingCartItem.title,
          quantity: _existingCartItem.quantity - 1,
          price: _existingCartItem.price,
        ),
      );
    } else {
      _cartProducts.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartProducts = {};
    notifyListeners();
  }
}
