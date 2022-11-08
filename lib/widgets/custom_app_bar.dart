import 'package:flutter/material.dart';

import '../screens/products_screen/products_screen.dart';
import '../styles/layout.dart';

PreferredSizeWidget CustomAppBar(context, title) {
  return AppBar(
    title: Text(
      title,
      style: TextStyle(fontFamily: 'Merriweather'),
    ),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: Layout.SPACING / 2),
        child: IconButton(
          onPressed: () {
            Layout.showFavourites = false;
            Navigator.of(context).pushReplacementNamed(ProductsScreen.routeName);
          },
          icon: Icon(Icons.shop),
        ),
      ),
    ],
  );
}
