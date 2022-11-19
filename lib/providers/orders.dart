import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cart_detail.dart';
import 'order_detail.dart';

class Orders with ChangeNotifier {
  String? userId;
  String? authToken;
  DateTime? authTokenExpiryDate;

  Orders(this.userId, this.authToken, this.authTokenExpiryDate);

  List<OrderDetail> _orderDetails = [];
  List<OrderDetail> get orderDetails {
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
    final List<OrderDetail> loadedOrders = [];

    extractedOrdersJson.forEach(
      (orderId, orderData) {
        loadedOrders.add(
          OrderDetail(
            orderProductId: orderId,
            orderDate: DateTime.parse(orderData['order_date']),
            products: (orderData['products'] as List<dynamic>)
                .map(
                  (ci) => CartDetail(
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

  Future<void> addOrder({required List<CartDetail> cartProducts, required double total}) async {
    try {
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
        OrderDetail(
          orderProductId: json.decode(response.body)['name'],
          orderDate: orderDate,
          products: cartProducts,
          amount: total,
        ),
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
