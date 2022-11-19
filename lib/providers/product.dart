import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String productId;
  final String title;
  final String description;
  final String imageUrl;
  final double price;

  bool isFavourite;

  Product({
    required this.productId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavourite = false,
  });

  Future<void> toggleFavourite(context, uid, authToken) async {
    final url = Uri.parse(
        'https://shop-8727a-default-rtdb.firebaseio.com/user_favourites/$uid/$productId.json?auth=$authToken');

    try {
      final response = await http.put(
        url,
        body: json.encode(!isFavourite),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Auth error');
      }
      isFavourite = !isFavourite;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
