import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../styles/layout.dart';
import '../../widgets/app_drawer.dart';
import '../cart_screen/cart_screen.dart';
import 'badge.dart';
import 'product_overview_tile.dart';

enum Filter {
  showFavourites,
  showAll,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/';

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(Layout.showFavourites),
      drawer: AppDrawer(Layout.showFavourites ? 'Favourite Products' : 'All Products'),
      body: ProductsGridView(context, Layout.showFavourites),
    );
  }

  PreferredSizeWidget MainAppBar(showFavourites) {
    return AppBar(
      title: showFavourites ? Text('Favourite Products') : Text('All Products'),
      actions: [
        Consumer<Cart>(
          builder: ((_, cart, badgeChild) => Badge(
                child: badgeChild!,
                value: cart.numberOfCartItems.toString(),
              )),
          child: Padding(
            padding: const EdgeInsets.only(right: Layout.SPACING / 2),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
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
        ? Center(
            child: Text(
              'You haven\'t picked any favourites yet.',
              style: Theme.of(context).textTheme.titleLarge,
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
                child: ProductOverviewTile(),
              );
            },
          );
  }
}
