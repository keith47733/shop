import 'package:flutter/material.dart';

class ProductItem with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavourite;

  ProductItem({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavourite = false,
  });

  // Don't use _toggleFavourite, since this method will be accessed from outside
  // this class.
  void toggleFavourite() {
    isFavourite = !isFavourite;
    // Now need to let all listeners know a property of this product has changed.
    // notifyListeners() is like a selective setState()
    notifyListeners();
  }
}
