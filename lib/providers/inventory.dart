import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'product.dart';

class Inventory with ChangeNotifier {
  String? userId;
  String? authToken;
  DateTime? authTokenExpiryDate;

  Inventory(this.userId, this.authToken, this.authTokenExpiryDate);

  List<Product> _products = [];
  List<Product> get products {
    return [..._products];
  }

  List<Product> get getFavouriteProducts {
    return _products.where((indexProduct) => indexProduct.isFavourite).toList();
  }

  Future<void> fetchProducts({required bool filterByUser}) async {
    if (userId == null) {
      return;
    }

    final queryString = filterByUser ? '&orderBy="created_by"&equalTo="$userId"' : '';

    final productsUrl =
        Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products.json?auth=$authToken$queryString');

    final favouritesUrl =
        Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/user_favourites/$userId.json?auth=$authToken');

    try {
      final productsResponse = await http.get(productsUrl);
      if (productsResponse.body == 'null') {
        return;
      }

      final favouritesResponse = await http.get(favouritesUrl);
      final decodedFavouritesResponse = json.decode(favouritesResponse.body);

      final List<Product> fetchedProducts = [];
      Map<String, dynamic> decodedProducts = json.decode(productsResponse.body);

      decodedProducts.forEach((productId, productData) {
        fetchedProducts.add(Product(
          productId: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['image_url'],
          isFavourite: decodedFavouritesResponse == null ? false : decodedFavouritesResponse[productId] ?? false,
        ));
      });
      _products = fetchedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Product findProductById(String productItemId) {
    return _products.firstWhere((product) => product.productId == productItemId);
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'description': product.description,
            'image_url': product.imageUrl,
            'price': product.price,
            'created_by': userId,
          },
        ),
      );
      final decodedResponse = json.decode(response.body);
      if (decodedResponse['error'] != null) {
        throw HttpException(decodedResponse['error']['message']);
      }
      final newProduct = Product(
        productId: response.body,
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

  Future<void> updateProduct(String editProductId, Product editProduct) async {
    final exProductIndex = _products.indexWhere((product) => product.productId == editProductId);
    if (exProductIndex >= 0) {
      try {
        final url =
            Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products/$editProductId.json?auth=$authToken');
        final response = await http.patch(
          url,
          body: json.encode({
            'title': editProduct.title,
            'description': editProduct.description,
            'price': editProduct.price,
            'image_url': editProduct.imageUrl,
          }),
        );
        if (response.statusCode >= 400) {
          throw HttpException('Could not delete product');
        }
        _products[exProductIndex] = editProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  Future<void> deleteProduct(String delProductId) async {
    final url = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products/$delProductId.json?auth=$authToken');
    var exProductIndex = _products.indexWhere((product) => product.productId == delProductId);
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException('Could not delete product');
      }
      _products.removeAt(exProductIndex);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
