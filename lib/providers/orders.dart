import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  Future<void> fetchAllOrders() async {
    final url = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/orders.json');

    final http.Response response = await http.get(url);

    if (response.body == 'null') {
      return;
    }

    final extractedOrdersJson = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItem> loadedOrders = [];

    extractedOrdersJson.forEach(
      (orderId, orderData) {
        loadedOrders.add(
          OrderItem(
            orderItemId: orderId,
            orderDate: DateTime.parse(orderData['order_date']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (ci) => CartItem(
                    cartItemId: ci['id'],
                    title: ci['title'],
                    quantity: ci['quantity'],
                    price: ci['price'],
                  ),
                )
                .toList(),
            amount: orderData['amount'],
          ),
        );
      },
    );
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder({required List<CartItem> cartProducts, required double total}) async {
    final url = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/orders.json');
    final orderDate = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'order_date': orderDate.toIso8601String(),
          'products':
              cartProducts
                  .map((cp) => {
                        'id': cp.cartItemId,
                        'title': cp.title,
                        'quantity': cp.quantity,
                        'price': cp.price,
                      })
                  .toList(),
        },
      ),
    );
    _orders.insert(
      0,
      OrderItem(
        orderItemId: json.decode(response.body)['name'],
        orderDate: orderDate,
        products: cartProducts,
        amount: total,
      ),
    );
    notifyListeners();
  }
}
