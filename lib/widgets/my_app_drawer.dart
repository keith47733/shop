import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';
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
      elevation: Layout.ELEVATION,
      child: Scaffold(
        appBar: AppBar(
          elevation: Layout.ELEVATION,
          title: Text(
            'Bitches Be Shopping',
            style: TextStyle(fontFamily: 'Oswald'),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Layout.SPACING,
              horizontal: Layout.SPACING,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: Layout.SPACING),
                Center(
                  child: CircleAvatar(
                    radius: Layout.SPACING * 3,
                    backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                    child: Image.asset('assets/images/user.png'),
                  ),
                ),
                SizedBox(height: Layout.SPACING),
                Center(
                  child: Text(
                    '[${Provider.of<Auth>(context, listen: false).getUserId}]',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
                        ),
                  ),
                ),
                SizedBox(height: Layout.SPACING),
                Divider(
                  thickness: 1.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                MenuOption(
                  context: context,
                  handler: shopHandler,
                  icon: Icons.shop,
                  title: 'Shop',
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
                  title: 'Manage Inventory',
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
                MenuOption(
                  context: context,
                  handler: logoutHandler,
                  icon: Icons.logout,
                  title: 'Logout',
                ),
                Divider(
                  thickness: 1.0,
                  color: Theme.of(context).colorScheme.primary,
                ),
                SizedBox(height: Layout.SPACING),
                AboutListTile(
                  applicationName: 'Bitches Be Shopping',
                  applicationVersion: 'Version 1.1',
                  applicationLegalese: 'Don\t forget to read the fine print bitch.',
                  icon: Image.asset(
                    // width: MediaQuery.of(context).size.width * 0.20,
                    'assets/images/shopping.png',
                  ),
                ),
              ],
            ),
          ),
        ),
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

  void shopHandler(context) {
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

  void logoutHandler(context) {
    Navigator.of(context).pop();
    Provider.of<Auth>(context, listen: false).logout();
    Navigator.of(context).pushReplacementNamed('/');
  }
}
