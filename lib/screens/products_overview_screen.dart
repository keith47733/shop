import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inventory.dart';
import '../styles/layout.dart';
import '../widgets/product_overview_tile.dart';

class ProductsOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Shop')),
      // Use GridView.builder() when you don't know how many items you have.
      // Only the items on the screen will be rendered (for long lists).
      body: ProductsGridView(context),
    );
  }

  // This can be moved into a separate widget file.
  // If not, you need to pass context for the listener.
  Widget ProductsGridView(context) {
    // Can fetch data by setting up listener in the build() method.
    // This listener must be a child of a ChangeNotifierProvider.
    // In this case, .of<Products>(context)	means listen for changes in Products class,
    // as initialized in parent widget.
    // Now, only the widget that is listening rebuilds.
    final productsProvider = Provider.of<Inventory>(context);
    // This will search up the tree for the first ChangeNotifierProvider.
    // Now, access the provider class getter, which returns items, a copuy of _items.
    // // List<Product> get items {
    // //   return [..._items];
    // // }
    final products = productsProvider.products;

    return GridView.builder(
      padding: const EdgeInsets.all(Layout.SPACING),
      // Defines the grid's structure.
      // WithFixedCrossAxisCount specifies how many columns.
      // WithMaxCrossAxisExtent which defines a width in pixels and fits as
      // many columns as it can given the maxCrossAxisExtent: argument.
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: Layout.SPACING,
        mainAxisSpacing: Layout.SPACING,
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
