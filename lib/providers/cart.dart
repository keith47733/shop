import 'package:flutter/material.dart';

import 'cart_item.dart';

// The ChangeNotifierProvider for the cart will need to be in main.dart b/c
// cart information is needed in CartScreen() to list cart items,
// ProductsOverviewScreen() to put cart in AppBar, and
// ProductOverviewTile() to addToCart from GridTile,
class Cart with ChangeNotifier {
  // Initializing with {} ensures _items will never be null, thus we don't have to
  // worry about null checks.
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int numberOfCartItems() {
    // We're just gonna count the number of different products, not the total
    // number of items including products with qty > 1.
    // return _items.length;
    int numberOfCartItems = 0;
    _items.forEach((key, value) {
      numberOfCartItems = numberOfCartItems + _items[key]!.quantity;
    });
    return numberOfCartItems;
  }

  // Getters don't use a parameter list.
  // ie, don't put () after the getter name.
  double get cartTotal {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total = total + (cartItem.quantity * cartItem.price);
    });
    return total;
  }

  void addItem({
    required String productId,
    required String title,
    required double price,
  }) {
    if (_items.containsKey(productId)) {
      // .update() returns CartItem object with matching productId and passes it
      // to a function to update the existingCartItem.
      _items.update(
        productId,
        (existingCartItem) => CartItem(
          id: existingCartItem.id,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        // .putIfAbsent() requires a function that returns, in this case, a class
        // object () => CartItem to add _items
        () => CartItem(
          id: DateTime.now().toString(), // Create unique ID
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    // productId is a key in our _items map. Maps are conventient since they
    // have built in add and remove functions.
    _items.remove(productId);
    notifyListeners();
  }
}
