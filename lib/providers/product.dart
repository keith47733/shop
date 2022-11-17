import 'dart:convert';

import 'package:Shop/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/my_snack_bar.dart';

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

  Future<void> toggleFavourite(context, authToken, userId) async {
    final url = Uri.parse(
        'https://shop-8727a-default-rtdb.firebaseio.com/user_favourites/$userId/$productId.json?auth=$authToken');

    isFavourite = !isFavourite;
    notifyListeners();

    try {
      final response = await http.put(
        url,
        body: json.encode(isFavourite),
      );
      if (response.statusCode >= 400) {
        throw HttpException('Could not save favourite status');
      } else {
        if (isFavourite) {
          MySnackBar(context, 'Added $title to favourites');
        } else {
          MySnackBar(context, 'Removed $title from favourites');
        }
      }
    } catch (error) {
      isFavourite = !isFavourite;
      notifyListeners();
      MySnackBar(context, 'Could not update favourites');
    }
  }
}
