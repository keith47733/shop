import 'package:flutter/material.dart';

import 'cart_detail.dart';

class Cart with ChangeNotifier {
  Map<String, CartDetail> _cartDetails = {};
  Map<String, CartDetail> get cartDetails {
    return {..._cartDetails};
  }

  int get getNumberOfCartItems {
    int _numberOfCartItems = 0;
    _cartDetails.forEach(
      (_, _cartDetail) {
        _numberOfCartItems = _numberOfCartItems + _cartDetail.quantity;
      },
    );
    return _numberOfCartItems;
  }

  double get getCartTotal {
    double _total = 0.0;
    _cartDetails.forEach(
      (_, _cartDetail) {
        _total = _total + (_cartDetail.quantity * _cartDetail.price);
      },
    );
    return _total;
  }

  void addCartItem(
    String productId,
    String title,
    double price,
  ) {
    if (_cartDetails.containsKey(productId)) {
      _cartDetails.update(
        productId,
        (_cartDetail) => CartDetail(
          cartProductId: _cartDetail.cartProductId,
          title: _cartDetail.title,
          price: _cartDetail.price,
          quantity: _cartDetail.quantity + 1,
        ),
      );
    } else {
      _cartDetails.putIfAbsent(
        productId,
        () => CartDetail(
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
        (_cartDetail) => CartDetail(
          cartProductId: _cartDetail.cartProductId,
          title: _cartDetail.title,
          quantity: _cartDetail.quantity - 1,
          price: _cartDetail.price,
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
