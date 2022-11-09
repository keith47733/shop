import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../styles/layout.dart';
import '../../widgets/my_app_drawer.dart';
import '../cart_screen/cart_screen.dart';
import 'badge.dart';
import 'product_tile.dart';

enum Filter {
  showFavourites,
  showAll,
}

class ProductsScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(Layout.showFavourites),
      drawer: MyAppDrawer(Layout.showFavourites ? 'Favourite Products' : 'All Products'),
      body: ProductsGridView(context, Layout.showFavourites),
    );
  }

  PreferredSizeWidget MainAppBar(showFavourites) {
    return AppBar(
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          showFavourites ? 'Favourite Products' : 'Bitches Be Shopping',
          style: TextStyle(fontFamily: 'Merriweather'),
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
                  value: cart.numberOfCartItems.toString(),
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

  Widget ProductsGridView(context, _showFavourites) {
    final products =
        _showFavourites ? Provider.of<Products>(context).favouriteProducts : Provider.of<Products>(context).allProducts;

    return products.isEmpty
        ? Padding(
            padding: const EdgeInsets.all(Layout.SPACING * 4),
            child: Center(
              child: Text(
                'You haven\'t picked any favourites yet.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          )
        : GridView.builder(
            padding: EdgeInsets.all(Layout.SPACING),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: Layout.SPACING,
              mainAxisSpacing: Layout.SPACING * 2,
            ),
            itemCount: products.length,
            itemBuilder: (BuildContext context, int index) {
              return ChangeNotifierProvider.value(
                value: products[index],
                child: ProductTile(),
              );
            },
          );
  }
}
