import 'package:flutter/material.dart';

import 'cart_item.dart';
import 'order_item.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get order {
    return [..._orders];
  }

  void addOrder({
    required List<CartItem> cartProducts,
    required double total,
  }) {
    // By default, add() will add to the end of the list. Specifying an index of 0 means new orders will be added to the beginning of the list.
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
