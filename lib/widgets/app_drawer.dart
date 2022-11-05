import 'package:flutter/material.dart';

import '../styles/layout.dart';
import '../screens/orders_screen/orders_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Shop'),
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
                ListTile(
                  onTap: () => {
                    Navigator.of(context).pushReplacementNamed('/'),
                  },
                  leading: Icon(
                    Icons.shop,
                    size: Layout.ICONSIZE * 0.8,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  title: Text(
                    'Products',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
                ListTile(
                  onTap: () => {
                    Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName),
                  },
                  leading: Icon(
                    Icons.payment,
                    size: Layout.ICONSIZE * 0.8,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  title: Text(
                    'My Orders',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
