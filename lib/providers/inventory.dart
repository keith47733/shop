import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import 'product.dart';

class Inventory with ChangeNotifier {
  // List<ProductItem> _products = MOCK_INVENTORY;

  // We could add a constructor to Products that always accepts an authToken argument:
  // // String authToken;
  // // ProductsScreen(this.authToken);
  // But when we set up the Provider<Products> in main.dart we would have to pass an authToken argument, but we don't know it when the app is first launched. It could be done by passing arguments around, but we use Providers to avoid this. To do this we can use a ChangeNotifierProxyProvider in main.dart.

  // String? authToken;
  // Products(this.authToken, this._products);

  String authToken;
  String userId;
  Inventory(this.authToken, this.userId);

  List<Product> _products = [];
  List<Product> get products {
    return [..._products];
  }

  List<Product> get favouriteProducts {
    return _products.where((indexProduct) => indexProduct.isFavourite).toList();
  }

  Future<void> fetchProducts({required bool filterByUser}) async {
    // // final url = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products.json');
    // Need to add the authToken to ?auth= at the end of the http request url b/c our Firebase Realtime Database is 'locked down' for authenticated users only:
    // // final productsUrl = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products.json?auth=$authToken');
    // Can also add a query to the Firebase url to filter products whose ['created_by'] matches the current userId. eg, &orderBy="created_by"&equalTo="$userId" (the url syntax is Firebase specific).
    // Note you also need to create an index for this query in your Firebase project by adding this code to the rules: "products": {".indexOn": ["created_by"]}
    // // final productsUrl = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products.json?auth=$authToken&orderBy="created_by"&equalTo="$userId"');

    // Rather than write separate functions for All Products/Manage Inventory, pass a bool to the function and construct the url:
    final queryString = filterByUser ? '&orderBy="created_by"&equalTo="$userId"' : '';
    final productsUrl =
        Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products.json?auth=$authToken$queryString');

    try {
      final productsResponse = await http.get(productsUrl);

      if (productsResponse.body == 'null') {
        return;
      }

      // Copied from <Product> but we're not looking for a specific product, we want all the favourites for that user - /$userId.json? instead of /$Userid/$productId.Json
      final favouritesUrl =
          Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/user_favourites/$userId.json?auth=$authToken');
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
          // We need to check if there are any favourites for that user, then we have to check if the current productId is in the list of favouritesData. This can be done with a combination of ? : ??. eg, var ?? false returns var if var is not null or false if var is null.
          isFavourite: favouritesData == null ? false : favouritesData[productId] ?? false,
        ));
      });
      _products = loadedProducts;
      notifyListeners();
    } catch (error) {
      print('ERROR FETCHING ALL PRODUCTS');
      print('ERROR: $error');
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
