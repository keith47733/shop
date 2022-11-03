import 'package:flutter/material.dart';

class CartItem {
  final String cartItemId; // This is different than the product ID
  final String title;
  final double price;
  final int quantity;

  CartItem({
    required this.cartItemId,
    required this.title,
    required this.price,
    required this.quantity,
  });
}