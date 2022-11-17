import 'package:flutter/material.dart';

import 'cart_product.dart';

class Cart with ChangeNotifier {
  String authToken;
  String userId;
  Cart(this.authToken, this.userId);

  Map<String, CartProduct> _cartDetails = {};
  Map<String, CartProduct> get cartDetails {
    return {..._cartDetails};
  }

  int get numberOfCartItems {
    int numberOfCartItems = 0;
    _cartDetails.forEach((key, value) {
      numberOfCartItems = numberOfCartItems + _cartDetails[key]!.quantity;
    });
    return numberOfCartItems;
  }

  double get cartTotal {
    double total = 0.0;
    _cartDetails.forEach((key, cartItem) {
      total = total + (cartItem.quantity * cartItem.price);
    });
    return total;
  }

  void addCartItem(
    String productId,
    String title,
    double price,
  ) {
    if (_cartDetails.containsKey(productId)) {
      _cartDetails.update(
        productId,
        (existingCartItem) => CartProduct(
          cartProductId: existingCartItem.cartProductId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _cartDetails.putIfAbsent(
        productId,
        () => CartProduct(
          cartProductId: DateTime.now().toString(),
          quantity: 1,
          title: title,
          price: price,
        ),
      );
    }
    notifyListeners();
  }

  void removeProduct(String productId) {
    _cartDetails.remove(productId);
    notifyListeners();
  }

  void removeItem(String productId) {
    if (!_cartDetails.containsKey(productId)) {
      return;
    }
    if (_cartDetails[productId]!.quantity > 1) {
      _cartDetails.update(
        productId,
        (_existingCartItem) => CartProduct(
          cartProductId: _existingCartItem.cartProductId,
          title: _existingCartItem.title,
          quantity: _existingCartItem.quantity - 1,
          price: _existingCartItem.price,
        ),
      );
    } else {
      _cartDetails.remove(productId);
    }
    notifyListeners();
  }

  void clearCart() {
    _cartDetails = {};
    notifyListeners();
  }
}
