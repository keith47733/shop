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

    // response is a Json map for the Orders with an id: with a nested Json map for which one of the values is a nested list with Json maps for the CartItems:
    // {-NGsP2Jg27XdmSax1b8X: {amount: 5.550000000000001, order_date: 2022-11-14T18:10:03.777304, products: [{id: 2022-11-14 18:09:57.330707, price: 1.11, quantity: 1, title: product1!}, {id: 2022-11-14 18:09:58.439864, price: 2.22, quantity: 2, title: product2}]}}
    // Now to decode into a list of Orders!

		// response is non-nullable - it will, however, return a string 'null' if no records are found.

    if (response.body == 'null') {
      return;
    }

    final List<OrderItem> loadedOrders = [];

    final extractedOrdersJson = json.decode(response.body) as Map<String, dynamic>;

    extractedOrdersJson.forEach(
      (orderId, orderData) {
        // final String orderItemId;
        // final DateTime orderDate;
        // final List<CartItem> products;
        // final double amount;
        loadedOrders.add(
          OrderItem(
            orderItemId: orderId,
            // DateTime.parse() requried an Iso8601String.
            orderDate: DateTime.parse(orderData['order_date']),
            amount: orderData['amount'],
            // Tell Dart to format the ['products'] key's dynamic value as a List to which we can apply .map().
            products: (orderData['products'] as List<dynamic>)
                .map((ci) => CartItem(
                      cartItemId: ci['id'],
                      title: ci['title'],
                      quantity: ci['quantity'],
                      price: ci['price'],
                    ))
                .toList(),
          ),
        );
      },
    );
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder({required List<CartItem> cartProducts, required double total}) async {
    final url = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/orders.json');

    // Need to create the order date so that it's the same when we add it to the server and to memory below.
    final orderDate = DateTime.now();
    // CAN ADD ERROR HANDLING LATER.
    // If successful, response contains the Json code for what was posted.
    final response = await http.post(
      url,
      body: json.encode(
        {
          'amount': total,
          // .toIso8601String() is a string format that we can easily convert back to a DateTime object.
          'order_date': orderDate.toIso8601String(),
          'products':
              // Need to convert each Cartitem to a Json map. .map() creates the [] brackets and acts on each object in the cartProducts List<CartItem>.
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
