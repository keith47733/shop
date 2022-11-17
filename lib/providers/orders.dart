import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart_product.dart';
import 'order_product.dart';

class Orders with ChangeNotifier {
  String authToken;
  String userId;
  Orders(this.authToken, this.userId);

  List<OrderProduct> _orderDetails = [];
  List<OrderProduct> get orderDetails {
    return [..._orderDetails];
  }

  bool isOrders() {
    if (_orderDetails.length > 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> fetchOrders() async {
    final url = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');

    final http.Response response = await http.get(url);

    if (response.body == 'null') {
      return;
    }

    final extractedOrdersJson = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderProduct> loadedOrders = [];

    extractedOrdersJson.forEach(
      (orderId, orderData) {
        loadedOrders.add(
          OrderProduct(
            orderProductId: orderId,
            orderDate: DateTime.parse(orderData['order_date']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (ci) => CartProduct(
                    cartProductId: ci['id'],
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
    _orderDetails = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder({required List<CartProduct> cartProducts, required double total}) async {
    final url = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/orders/$userId.json?auth=$authToken');
    final orderDate = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          'order_date': orderDate.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.cartProductId,
                    'title': cp.title,
                    'quantity': cp.quantity,
                    'price': cp.price,
                  })
              .toList(),
        },
      ),
    );
    _orderDetails.insert(
      0,
      OrderProduct(
        orderProductId: json.decode(response.body)['name'],
        orderDate: orderDate,
        products: cartProducts,
        amount: total,
      ),
    );
    notifyListeners();
  }
}
