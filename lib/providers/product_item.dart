import 'package:flutter/material.dart';

class ProductItem with ChangeNotifier {
  final String productItemId;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  ProductItem({
    required this.productItemId,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  void toggleFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
