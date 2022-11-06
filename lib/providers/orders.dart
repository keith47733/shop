import 'package:flutter/material.dart';

import 'cart_item.dart';
import 'order_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get order {
    return [..._orders];
  }

  bool isOrders() {
    if (_orders.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  void addOrder({
    required List<CartItem> cartProducts,
    required double total,
  }) {
    _orders.insert(
      0,
      OrderItem(
        orderItemId: DateTime.now().toString(),
        amount: total,
        products: cartProducts,
        orderDate: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
