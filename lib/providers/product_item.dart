import 'dart:convert';

import 'package:Shop/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/my_snack_bar.dart';

class ProductItem with ChangeNotifier {
  final String productItemId;
  final String title;
  final String description;
  final String imageUrl;
  final double price;

  bool isFavourite;

  ProductItem({
    required this.productItemId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.price,
    this.isFavourite = false,
  });

  Future<void> toggleFavourite(BuildContext context) async {
    final url = Uri.parse('https://shop-8727a-default-rtdb.firebaseio.com/products/$productItemId.json');

    isFavourite = !isFavourite;
    notifyListeners();

    try {
      final response = await http.patch(url, body: json.encode({'is_favourite': isFavourite}));
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
