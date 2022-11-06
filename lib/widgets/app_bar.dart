import 'package:flutter/material.dart';

import '../screens/products_overview_screen/products_overview_screen.dart';
import '../styles/layout.dart';

PreferredSizeWidget CustomAppBar(context, title) {
  return AppBar(
    title: Text(title),
    actions: [
      Padding(
        padding: const EdgeInsets.only(right: Layout.SPACING / 2),
        child: IconButton(
          onPressed: () {
            Layout.showFavourites = false;
            Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName);
          },
          icon: Icon(Icons.shop),
        ),
      ),
    ],
  );
}
