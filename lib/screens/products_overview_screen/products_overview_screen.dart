import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/products.dart';
import '../../styles/layout.dart';
import '../../widgets/app_drawer.dart';
import '../cart_screen/cart_screen.dart';
import 'badge.dart';
import 'product_overview_tile.dart';

// Interestingly, without filtering logic, this can be a StatelessWidget. Widget rebuilds are triggered by Provider-Listeners/Consumers. But when applying filtering logic, it will affect the entire widget screen, so we need a Stateful widget.
// The filtering state is best handled in the state object with SetState(), but logic to fetch filtered data is best handled in the data provider methods.

// An enum is essentially an array [0, 1, 2, ...] where each index is given a name.
enum Filter {
  showFavourites,
  showAll,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/';
  // bool _showFavourites;

  // ProductsOverviewScreen(this._showFavourites);

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  // bool _showFavourites = false;

  @override
  Widget build(BuildContext context) {
    // bool _showFavourites = ModalRoute.of(context)!.settings.arguments as bool;
    // We only want to rebuild the entire list if Inventory._showFavourites changes. So we only need to fetch that property since the list won't change. We don't need to set up a listener.
    // // final displayProducts = Provider.of<Inventory>(context, listen: false);

    return Scaffold(
      appBar: MainAppBar(Layout.showFavourites),
      drawer: AppDrawer(),
      // Use GridView.builder() when you don't know how many items you have.
      // Only the items on the screen will be rendered (for long lists).
      body: ProductsGridView(context, Layout.showFavourites),
    );
  }

  // This can be moved into a separate widget file.
  Widget ProductsGridView(context, _showFavourites) {
    // Can fetch data by setting up listener in the build() method. This listener must be a child of a ChangeNotifierProvider. In this case, .of<Products>(context)	means listen for changes in Products class, as initialized in parent widget. Now, only the widget that is listening rebuilds. This will search up the tree for the first ChangeNotifierProvider:
    // // final productsProvider = Provider.of<Inventory>(context);

    // Now, access the appropriate provider method to return a list of items (a copy of _items), depending on the filtering logic. For example, this statement (with the one above) would return a copy of ALL items.
    // // final products = productsProvider.allProducts;

    // Now combine the Provider statements and apply filtering logic to return a list of items and assign to variable 'products':
    final products =
        _showFavourites ? Provider.of<Products>(context).favouriteProducts : Provider.of<Products>(context).allProducts;

    return products.isEmpty
        ? Center(child: Text('You haven\'t picked any favourites yet.'))
        : GridView.builder(
            padding: EdgeInsets.all(Layout.SPACING),
            // The gridDelegate, SliverGridDelegateWithFixedCrossAxisCount() defines the grid's structure.
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
            // Define how each grid item should look with the item builder.
            itemBuilder: (BuildContext context, int index) {
              // Even with advanced state management, it's still acceptable to pass arguments to custom widgets. If the context is not required, you can use a .value Provider. In fact, this is the preferred method for ListViews, GridViews, where it only renders the visible items. Passing context will cause bugs in the list since Flutter recycles state/context data for the visible items.
              // This will setup a ChangeNotifierProvider for each item in the list. To do this, it requires a value (the index of the list item) which acts like a key.
              return ChangeNotifierProvider.value(
                value: products[index],
                // Note: ChangeNotifierProvider disposes data when the screen is destroyed so a dispose() method is not required. eg, popped() off the stack.
                child: ProductOverviewTile(),
                // Here we would need to pass productId to ProductOverviewTile just it can pass it on to the ProductDetailScreen, but ProductOverviewTile doesn't need it. Passing these arguments like this quickly gets cumbersome AND causes unnecessary setState rebuilds for all widgets/screens from the top-down - usually the entire app since the data/state must be managed in main.dart. (See the Recipe app where state data is handled in main.dart.)
                // ProductOverviewTile(
                //   products[index].id,
                //   products[index].title,
                //   products[index].price,
                //   products[index].imageUrl,
                // ),
              );
            },
          );
  }

  PreferredSizeWidget MainAppBar(showFavourites) {
    return AppBar(
      title: showFavourites ? Text('Favourite Products') : Text('All Products'),
      actions: [
        // PopupMenuButton(
        //   // Rather than return an interger for selection, return the enum name.
        //   onSelected: (Filter selectedFilter) {
        //     // _showFavourites needs to passed from the IconButton to ProductsGridView where the list is actually built and displayed.
        //     setState(() {
        //       if (selectedFilter == Filter.showFavourites) {
        //         _showFavourites = true;
        //       } else {
        //         _showFavourites = false;
        //       }
        //     });
        //   },
        //   icon: Icon(Icons.more_vert),
        //   itemBuilder: (_) => [
        //     // More verbose to use enum for values (initialized above). Essentially assigning values of value: 0, and value: 1,
        //     PopupMenuItem(
        //       child: Text('Show favourites'),
        //       value: Filter.showFavourites,
        //     ),
        //     PopupMenuItem(
        //       child: Text('Show all'),
        //       value: Filter.showAll,
        //     ),
        //   ],
        // ),
        Consumer<Cart>(
          builder: ((_, cart, badgeChild) => Badge(
                child: badgeChild!, // This is the Badge widget's child
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
        // Children outside the Consumer builder won't be rebuilt.
      ],
    );
  }
}
