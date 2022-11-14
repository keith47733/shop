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
  bool _isInit = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // initState would be the ideal method to load products from database since it only executs once when the widget is built. However, remember (context) isn't available right away in initState() b/c the widget has not been completely built. (Note Provider will work if you set listen: false).
    // // Provider.of<Products>(context).fetchAllProducts();
    // One 'hack' work-around is to use
    // // Future.delayed(Duration.zero).then(() {...})
    // Better to use didChangeDependencies like we did previously.
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      // fetchAllProducts() is a Future (Future<void> fetchAllProducst() async{}), so code in products_screen.dart will not continue until code in data provider method is complete.
      Provider.of<Products>(context).fetchAllProducts().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(Layout.showFavourites),
      drawer: MyAppDrawer(Layout.showFavourites ? 'Favourite Products' : 'All Products'),
      body: _isLoading ? Center(child: CircularProgressIndicator()) : ProductsGridView(context, Layout.showFavourites),
    );
  }

  PreferredSizeWidget MainAppBar(showFavourites) {
    return AppBar(
      elevation: Layout.ELEVATION,
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
            'There are no products available at this time.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(Layout.SPACING),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: Layout.SPACING,
        mainAxisSpacing: Layout.SPACING,
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
