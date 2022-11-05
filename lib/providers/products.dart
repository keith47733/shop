import 'package:Shop/mocks/mock_inventory.dart';
import 'package:Shop/providers/product_item.dart';
import 'package:flutter/material.dart';

class Products with ChangeNotifier {
  // The Products object class inherits properties/methods from ChangeProvider.
  // (eg, like an inherited widget.)

  // Not final...will change.
  // _items cannot be accessed from outside this class...so it requires "getters".
  List<ProductItem> _products = MOCK_INVENTORY;

  List<ProductItem> get allProducts {
    // The filtering logic was moved to the ProductsOverviewScreen widget.
    // if (_showFavourites) {
    //   // Note that _products is a list, so you must return .toList().
    //   return _products.where((indexProduct) => indexProduct.isFavourite).toList();
    // } else {
    return [..._products];
    // }
  }

  List<ProductItem> get favouriteProducts {
    return _products.where((indexProduct) => indexProduct.isFavourite).toList();
  }

  // The getter returns 'items' which is a copy of '_items'. If widgets could
  // modify _items directly, the provider wouldn't be able to notify listeners.
  // Therefore, all changes to data are made in the provider class, and listening
  // widgets are notified and sent a copy of the new data.

  // This will return a Product instance where the product's id matches
  // the productId string passed to the getter.
  ProductItem findProductbyId(String productId) {
    return _products.firstWhere((product) => product.id == productId);
  }

  // We can return a copy of the list with only products that have been marked
  // favourite. The showFavourites is set by the PopUpMenu in ProductsOverviewScreen.
  // _showFavourites can be private - only this class will use it.
  // So we need to call an Inventory.method() that sets _showFavourites.
  // Note this would apply to the app-wide state. But we're really only interested
  // in this functionality in the ProductsOverviewScreen.
  // You should manage filtering logic in a widget - not globally.
  // // bool _showFavourites = false;
  // // void showFavourites() {
  // // 	_showFavourites = true;
  // // 	notifyListeners();
  // // }
  // // void showAll() {
  // // 	_showFavourites = false;
  // // 	notifyListeners();
  // // }

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
