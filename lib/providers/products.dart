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

  ProductItem findProductById(String productItemId) {
    return _products.firstWhere((product) => product.productItemId == productItemId);
  }

  void addProduct(ProductItem product) {
    final newProduct = ProductItem(
      productItemId: DateTime.now().toString(),
      title: product.title,
      description: product.description,
      price: product.price,
      imageUrl: product.imageUrl,
      isFavourite: false,
    );
    // _products.add(newProduct);
    _products.insert(0, newProduct);
    notifyListeners();
  }

  void updateProduct(String editedProductItemId, ProductItem editedProduct) {
    final productIndex = _products.indexWhere((product) => product.productItemId == editedProductItemId);
    if (productIndex >= 0) {
      _products[productIndex] = editedProduct;
      notifyListeners();
    }
  }

	void deleteProduct (String deleteProductItemId) {
		_products.removeWhere((product) => product.productItemId == deleteProductItemId);
		notifyListeners();
	}
}
