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

  int cartCount() {
    // We're just gonna count the number of different products, not the total
    // number of items including products with qty > 1.
    return _items.length;
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
          cartItemId: existingCartItem.cartItemId,
          title: existingCartItem.title,
          price: existingCartItem.price,
          quantity: existingCartItem.quantity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        // .putIfAbsent() requires a function that returns a class object () =>
        () => CartItem(
          cartItemId: DateTime.now().toString(), // Create unique ID
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }
}
