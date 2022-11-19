import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/inventory.dart';
import '../../styles/layout.dart';
import '../../widgets/error_message.dart';
import '../../widgets/loading_spinner.dart';
import '../../widgets/main_app_bar.dart';
import '../../widgets/my_app_drawer.dart';
import 'product_tile.dart';

enum Filter {
  showFavourites,
  showAll,
}

class ProductsScreen extends StatelessWidget {
  static const routeName = '/products_screen';

  Future<void> _fetchProducts(context) async {
    await Provider.of<Inventory>(context, listen: false).fetchProducts(filterByUser: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(context, Layout.showFavourites ? 'Favourite Products' : 'Shop'),
      drawer: MyAppDrawer(Layout.showFavourites ? 'Favourite Products' : 'Shop'),
      body: FutureBuilder(
        future: _fetchProducts(context),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          }
          if (snapshot.error != null) {
            return ErrorMessage(ctx);
          }
          return ProductsGridView(context, Layout.showFavourites);
        },
      ),
    );
  }

  Widget ProductsGridView(context, _showFavourites) {
    final products = Layout.showFavourites
        ? Provider.of<Inventory>(context, listen: false).getFavouriteProducts
        : Provider.of<Inventory>(context, listen: false).products;

    if (_showFavourites && products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(Layout.SPACING * 4),
        child: Center(
          child: Text(
            'Click on the heart to mark a product as a favourite.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    }

    if (!_showFavourites && products.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(Layout.SPACING * 4),
        child: Center(
          child: Text(
            'There are no products available.\nAdd a product to Your Products or try again later.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        vertical: Layout.SPACING * 2,
        horizontal: Layout.SPACING * 1.5,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: max(MediaQuery.of(context).size.width ~/ 400, 1),
        childAspectRatio: 1,
        // childAspectRatio: 3 / 2,
        crossAxisSpacing: Layout.SPACING * 2,
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
