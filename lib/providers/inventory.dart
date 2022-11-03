import 'package:Shop/mocks/mock_inventory.dart';
import 'package:Shop/providers/product.dart';
import 'package:flutter/material.dart';

class Inventory with ChangeNotifier {
  // The Products object class inherits properties/methods from ChangeProvider.
  // (eg, like an inherited widget.)

  // Not final...will change.
  // _items cannot be accessed from outside this class...so it requires "getters".
  List<Product> _products = MOCK_INVENTORY;

  List<Product> get products {
    return [..._products];
  }

  // The getter returns 'items' which is a copy of '_items'. If widgets could
  // modify _items directly, the provider wouldn't be able to notify listeners.
  // Therefore, all changes to data are made in the provider class, and listening
  // widgets are notified and sent a copy of the new data.

  // This will return a Product instance where the product's id matches
  // the productId string passed to the getter.
  Product findProductbyId(String productId) {
    return _products.firstWhere((product) => product.id == productId);
  }

  // Need a function to tell all listeners that state data has changed.
  // For example, when a product is added with the addProduct() method,
  // you can call notifyListeners();
  void addProduct() {
    // _items.add();
    notifyListeners();
  }

  // The listener must be created in the parent widget of the widget interested
  // in the data.
}
