import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/inventory.dart';
import '../../styles/layout.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_app_drawer.dart';
import 'edit_product_screen.dart';
import 'user_product_tile.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user_products_screen';

  // Before we scoped Inventory products to a user, we didn't need to reload the inventory list when first visiting the screen - all the products had been loaded into memory in the ProductsScreen. So we need to load the products and filterByUser when we first load this screen now. This is best done with a FutureBuilder.

  Future<void> _fetchInventory(context) async {
    print('***-IN FETCH INVENTORY');
    await Provider.of<Inventory>(context, listen: false).fetchProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    print('1-BUILD METHOD');
    // When using a FutureBuilder, this would trigger an infinite loop. When the widget/screen is built, FutureBuilder will fetchProducts(), this will update the products in Inventory, and the listener below would rebuild the widget/screen. But we still want the screen contents to rebuild if there is a change to Inventory (eg, editing, deleting products). So we can use a Consumer to rebuild what we want rather than a Listener that would rebuild the widget/screen.
    // // final userProducts = Provider.of<Inventory>(context);

    return Scaffold(
      appBar: MyAppBar('Manage Inventory', Icon(Icons.note_add), () => _appBarHandler(context)),
      drawer: MyAppDrawer('Manage Inventory'),
      body: FutureBuilder(
        future: _fetchInventory(context),
        // The Future<void> _fetchInventory is returning a snapshot - an object with the results of the await (eg, connection state, error, etc.) NOT an instance of Inventory.
        builder: ((ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          // We can't test if inventory.products.isEmpty yet, b/c we don't get an instance of Inventory until the Consumer<Inventory> below. We'll have to check for no products after the Consumer<Inventory>.
          // if (inventory.products.isEmpty) {
          //   return NoProductsInInventory(context);
          // }
          return BuildProductList(context);
        }),
      ),
    );
  }

  void _appBarHandler(context) {
    Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: 'add');
  }

  Widget BuildProductList(context) {
    return RefreshIndicator(
      onRefresh: () => _fetchInventory(context),
      child: Consumer<Inventory>(
        // NOW, the Consumer is returning an instance of Inventory in the builder:
        builder: (ctx, inventory, _) {
          if (inventory.products.isEmpty) {
            return NoProductsInInventory(context);
          }
          return Padding(
            padding: const EdgeInsets.symmetric(
              vertical: Layout.SPACING / 2,
              horizontal: Layout.SPACING,
            ),
            child: ListView.builder(
              itemCount: inventory.products.length,
              itemBuilder: (_, index) {
                return UserProductTile(
                  inventory.products[index].productId,
                  inventory.products[index].title,
                  inventory.products[index].imageUrl,
                );
              },
            ),
          );
        },
      ),
    );
  }

  Widget NoProductsInInventory(context) {
    return Padding(
      padding: const EdgeInsets.all(Layout.SPACING * 6),
      child: Center(
        child: Text(
          'There are no products in your inventory.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
