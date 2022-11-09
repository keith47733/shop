import 'package:flutter/material.dart';

import '../screens/cart_screen/cart_screen.dart';
import '../screens/orders_screen/orders_screen.dart';
import '../screens/products_screen/products_screen.dart';
import '../screens/user_products_screen/user_products_screen.dart';
import '../styles/layout.dart';

class MyAppDrawer extends StatelessWidget {
  final String currentScreen;
  MyAppDrawer(this.currentScreen);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text(
              'Bitches Be Shopping',
              style: TextStyle(fontFamily: 'Merriweather'),
            ),
            automaticallyImplyLeading: false,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Layout.SPACING,
              horizontal: Layout.SPACING,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MenuOption(
                  context: context,
                  handler: allProductsHandler,
                  icon: Icons.shop,
                  title: 'All Products',
                ),
                MenuOption(
                  context: context,
                  handler: favouriteProductsHandler,
                  icon: Icons.favorite_outline,
                  title: 'Favourite Products',
                ),
                MenuOption(
                  context: context,
                  handler: yourProductsHandler,
                  icon: Icons.add_shopping_cart,
                  title: 'Your Products',
                ),
                MenuOption(
                  context: context,
                  handler: cartHandler,
                  icon: Icons.shopping_cart,
                  title: 'Cart',
                ),
                MenuOption(
                  context: context,
                  handler: ordersHandler,
                  icon: Icons.payment,
                  title: 'Orders',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget MenuOption({
    required BuildContext context,
    required Function handler,
    required IconData icon,
    required String title,
  }) {
    return ListTile(
      onTap: currentScreen != title ? () => handler(context) : () {},
      leading: Icon(
        icon,
        size: Layout.ICONSIZE * 0.8,
        color: Theme.of(context).colorScheme.onSurfaceVariant,
      ),
      title: Text(
        title,
        style: currentScreen == title
            ? Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                )
            : Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
      ),
    );
  }

  void allProductsHandler(context) {
    Layout.showFavourites = false;
    Navigator.of(context).pushReplacementNamed(ProductsScreen.routeName);
  }

  void favouriteProductsHandler(context) {
    Layout.showFavourites = true;
    Navigator.of(context).pushReplacementNamed(ProductsScreen.routeName);
  }

  void yourProductsHandler(context) {
    Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName);
  }

  void cartHandler(context) {
    Navigator.of(context).pushReplacementNamed(CartScreen.routeName);
  }

  void ordersHandler(context) {
    Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
  }
}
