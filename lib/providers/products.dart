import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../mocks/mock_inventory.dart';
import '../models/http_exception.dart';
import '../widgets/my_snack_bar.dart';
import 'product_item.dart';

class Products with ChangeNotifier {
  // List<ProductItem> _products = MOCK_INVENTORY;
  List<ProductItem> _products = [];

  List<ProductItem> get allProducts {
    return [..._products];
  }

  List<ProductItem> get favouriteProducts {
    return _products.where((indexProduct) => indexProduct.isFavourite).toList();
  }

  Future<void> fetchAllProducts() async {
    final url = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.get(url);

      if (response.body == 'null') {
        return;
      }

      Map<String, dynamic> extractedData = json.decode(response.body);

      final List<ProductItem> loadedProducts = [];

      extractedData.forEach((productId, productData) {
        loadedProducts.add(ProductItem(
          productItemId: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['image_url'],
          isFavourite: productData['is_favourite'],
        ));
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      print('ERROR FETCHING ALL PRODUCTS');
      print('ERROR: $error');
    }
  }

  ProductItem findProductById(String productItemId) {
    return _products.firstWhere((product) => product.productItemId == productItemId);
  }

  Future<void> addProduct(ProductItem product) async {
    final url = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products.json');

    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'image_url': product.imageUrl,
            'price': product.price,
            'is_favourite': product.isFavourite,
          },
        ),
      );
      final newProduct = ProductItem(
        productItemId: response.body,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavourite: false,
      );
      _products.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> updateProduct(String editProductId, ProductItem editProduct) async {
    final productIndex = _products.indexWhere((product) => product.productItemId == editProductId);
    if (productIndex >= 0) {
      final url = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products/$editProductId.json');
      await http.patch(
        url,
        body: json.encode({
          'title': editProduct.title,
          'description': editProduct.description,
          'price': editProduct.price,
          'image_url': editProduct.imageUrl,
        }),
      );
      _products[productIndex] = editProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String delProductId) async {
    final url = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products/$delProductId.json');

    var existingProductIndex = _products.indexWhere((product) => product.productItemId == delProductId);
    var existingProduct = _products[existingProductIndex];

    _products.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _products.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product');
    }
    existingProduct.dispose();
  }
}
