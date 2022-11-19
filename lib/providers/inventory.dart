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

  List<Product> get favouriteProducts {
    return _products.where((indexProduct) => indexProduct.isFavourite).toList();
  }

  Future<void> fetchProducts({required bool filterByUser}) async {
    print('SEARCH BY USER ID: $filterByUser');
    print('SEARCH BY USER ID: $userId');
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
      print('GET PRODUCTS FROM SERVER: $productsResponse');
      if (productsResponse.body == 'null') {
        print('INSIDE PRODUCTSRESPONSE == NULL');
        return;
      }

      final favouritesResponse = await http.get(favouritesUrl);
      final favouritesData = json.decode(favouritesResponse.body);

      final List<Product> loadedProducts = [];
      Map<String, dynamic> extractedData = json.decode(productsResponse.body);

      extractedData.forEach((productId, productData) {
        loadedProducts.add(Product(
          productId: productId,
          title: productData['title'],
          description: productData['description'],
          price: productData['price'],
          imageUrl: productData['image_url'],
          isFavourite: favouritesData == null ? false : favouritesData[productId] ?? false,
        ));
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      print('ERROR FETCHING PRODUCTS BY USER ID');
    }
  }

  Product findProductById(String productItemId) {
    return _products.firstWhere((product) => product.productId == productItemId);
  }

  Future<void> addProduct(Product product) async {
		    print('ADD PRODUCT USERID: $userId');


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
    final productIndex = _products.indexWhere((product) => product.productId == editProductId);
    if (productIndex >= 0) {
      final url =
          Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products/$editProductId.json?auth=$authToken');
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
    final url = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products/$delProductId.json?auth=$authToken');

    var existingProductIndex = _products.indexWhere((product) => product.productId == delProductId);
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
