import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/inventory.dart';
import '../../styles/layout.dart';
import '../../widgets/error_message.dart';
import '../../widgets/loading_spinner.dart';
import '../../widgets/main_app_bar.dart';
import '../../widgets/my_app_drawer.dart';
import 'edit_product_screen.dart';
import 'user_product_tile.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user_products_screen';

  Future<void> _fetchInventory(context) async {
    await Provider.of<Inventory>(context, listen: false).fetchProducts(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(context, 'Manage Inventory'),
      drawer: MyAppDrawer('Manage Inventory'),
      bottomNavigationBar: BottomAppBar(
        elevation: Layout.ELEVATION,
				color: Theme.of(context).colorScheme.primary,
        shape: CircularNotchedRectangle(),
				notchMargin: Layout.RADIUS,
				clipBehavior: Clip.antiAlias,
				child: SizedBox(height: Layout.SPACING * 2.5),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _FABHandler(context),
        child: Icon(Icons.add),
      ),
      body: FutureBuilder(
          future: _fetchInventory(context),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LoadingSpinner();
            }
            if (snapshot.error != null) {
              return ErrorMessage(ctx);
            }
            return BuildProductList(context);
          }),
    );
  }

  void _FABHandler(context) {
    Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: 'add');
  }

  Widget BuildProductList(context) {
    return RefreshIndicator(
      onRefresh: () => _fetchInventory(context),
      child: Consumer<Inventory>(
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
