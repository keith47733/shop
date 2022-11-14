import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products.dart';
import '../../styles/layout.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_app_drawer.dart';
import 'edit_product_screen.dart';
import 'user_product_tile.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user_products_screen';

	Future<void> _refreshUserProducts(context) async {
		await Provider.of<Products>(context, listen: false).fetchAllProducts();
	}

  @override
  Widget build(BuildContext context) {
    final _userProducts = Provider.of<Products>(context);

    return Scaffold(
      appBar: MyAppBar('Your Products', Icon(Icons.note_add), () => _appBarHandler(context)),
      drawer: MyAppDrawer('Your Products'),
      body: _userProducts.allProducts.isEmpty
			? Padding(
        padding: const EdgeInsets.all(Layout.SPACING * 6),
        child: Center(
          child: Text(
            'There are no products in stock.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      )
			: BuildProductList(context, _userProducts),
    );
  }

  void _appBarHandler(context) {
    Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: 'add');
  }

  Widget BuildProductList(context, userProducts) {
    return RefreshIndicator(
			onRefresh: () => _refreshUserProducts(context),
			child: Padding(
				padding: const EdgeInsets.symmetric(
					vertical: Layout.SPACING / 2,
					horizontal: Layout.SPACING,
				),
				child: ListView.builder(
					itemCount: userProducts.allProducts.length,
					itemBuilder: (_, index) {
						return UserProductTile(
							userProducts.allProducts[index].productItemId,
							userProducts.allProducts[index].title,
							userProducts.allProducts[index].imageUrl,
						);
					},
				),
			),
		);
  }
}
