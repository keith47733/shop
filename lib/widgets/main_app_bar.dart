import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../screens/cart_screen/cart_screen.dart';
import '../styles/layout.dart';
import 'badge.dart';

PreferredSizeWidget MainAppBar(context, title) {
    return AppBar(
      elevation: Layout.ELEVATION,
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          title,
          style: TextStyle(fontFamily: 'Oswald'),
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(CartScreen.routeName);
          },
          child: Consumer<Cart>(
            builder: ((_, cart, badgeChild) => Badge(
                  child: badgeChild!,
                  value: cart.getNumberOfCartItems.toString(),
                )),
            child: Padding(
              padding: const EdgeInsets.only(right: Layout.SPACING),
              child: Icon(Icons.shopping_cart),
            ),
          ),
        ),
      ],
    );
  }