import 'package:flutter/material.dart';

import '../mocks/mock_inventory.dart';
import 'product_item.dart';

class Products with ChangeNotifier {
  List<ProductItem> _products = MOCK_INVENTORY;

  List<ProductItem> get allProducts {
    return [..._products];
  }

  List<ProductItem> get favouriteProducts {
    return _products.where((indexProduct) => indexProduct.isFavourite).toList();
  }

  ProductItem findProductbyId(String productId) {
    return _products.firstWhere((product) => product.productItemId == productId);
  }

  void addProduct() {
    notifyListeners();
  }
}
