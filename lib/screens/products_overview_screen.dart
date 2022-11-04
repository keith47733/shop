import 'package:Shop/screens/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/inventory.dart';
import '../styles/layout.dart';
import '../widgets/badge.dart';
import '../widgets/product_overview_tile.dart';

enum Filter {
  showFavourites,
  showAll,
}

// Interestingly, without filtering logic, this can be a StatelessWidget. Widget
// rebuilds are triggered by Provider-Listeners/Consumers. But when applying filtering
// logic, it will affect the entire widget screen, so we need a Stateful widget.
// The filtering logic is handled in the state object.

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool _showFavourites = false;
  @override
  Widget build(BuildContext context) {
    // We only want to rebuild the entire list if Inventory._showFavourites changes.
    // So we only need to fetch that property since the list won't change.
    // // final displayProducts = Provider.of<Inventory>(context, listen: false);
    // But we want to provide filtering login within this widget screen.
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          PopupMenuButton(
            // Rather than return an interger for selection, it will be of enum type.
            onSelected: (Filter selectedFilter) {
              // _showFavourites needs to passed on to ProductsGridView where
              // the list is built and displayed.
              setState(() {
                if (selectedFilter == Filter.showFavourites) {
                  _showFavourites = true;
                } else {
                  _showFavourites = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              // More verbose to use enum for values (initialized above).
              PopupMenuItem(child: Text('Show only favourites'), value: Filter.showFavourites),
              PopupMenuItem(child: Text('Show all'), value: Filter.showAll),
            ],
          ),
          Consumer<Cart>(
            builder: ((_, cart, badgeChild) => Badge(
                  child: badgeChild!, // This is the Badge widget's child
                  value: cart.numberOfCartItems().toString(),
                )),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ), // The consumer's child outside the builder won't be rebuilt
          ),
        ],
      ),
      // Use GridView.builder() when you don't know how many items you have.
      // Only the items on the screen will be rendered (for long lists).
      body: ProductsGridView(context, _showFavourites),
    );
  }

  // This can be moved into a separate widget file.
  Widget ProductsGridView(context, _showFavourites) {
    // Can fetch data by setting up listener in the build() method.
    // This listener must be a child of a ChangeNotifierProvider.
    // In this case, .of<Products>(context)	means listen for changes in Products class,
    // as initialized in parent widget.
    // Now, only the widget that is listening rebuilds.
    // // // final productsProvider = Provider.of<Inventory>(context);
    // This will search up the tree for the first ChangeNotifierProvider.
    // Now, access the provider class getter, which returns items, a copuy of _items.
    // // List<Product> get items {
    // //   return [..._items];
    // // }
    // // // final products = productsProvider.allProducts;

    // Now combine the Provider statement and apply filtering logic:
    final products = _showFavourites
        ? Provider.of<Inventory>(context).favouriteProducts
        : Provider.of<Inventory>(context).allProducts;

    return products.isEmpty
        ? Center(child: Text('You haven\'t picked any favourites yet.'))
        : GridView.builder(
            padding: const EdgeInsets.all(Layout.SPACING),
            // Defines the grid's structure.
            // WithFixedCrossAxisCount specifies how many columns.
            // WithMaxCrossAxisExtent which defines a width in pixels and fits as
            // many columns as it can given the maxCrossAxisExtent: argument.
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 3 / 2,
              crossAxisSpacing: Layout.SPACING,
              mainAxisSpacing: Layout.SPACING * 2,
            ),
            itemCount: products.length,
            // Defines how each grid item should look
            itemBuilder: (BuildContext context, int index) {
              // Even with advanced state management, it's still acceptable to pass
              // arguements to custom widgets.
              // If the context is not required, you can use a .value Provider.
              // In fact, this is the preferred method for ListViews, GridViews, where it
              // only renders the visible items. Passing context will cause bugs in the list
              // because Flutter will recycle data b/c context is only for visible items.
              // .value Provider attaches data to all items in list and used when built
              // on-screen.
              return ChangeNotifierProvider.value(
                value: products[index],
                // Note: ChangeNotifierProvider disposes data when screen is destroyed
                // (eg, popped() off stack).
                child: ProductOverviewTile(
                    // But here we're passing productId just so ProductOverviewTile can
                    // pass it to ProductDetailScreen - ProductOverviewTile doesn't need it.
                    // Passing these arguments like this will quickly get cumbersome AND
                    // cause unnecessary setState rebuilds for all widgets/screens from
                    // top-down - the entire app!
                    // (See the Recipe app where state data is handled in main.dart.)
                    // products[index].id,
                    // products[index].title,
                    // products[index].price,
                    // products[index].imageUrl,
                    ),
              );
            },
          );
  }
}
