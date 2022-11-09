import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products.dart';
import '../../styles/layout.dart';
import '../../widgets/app_drawer.dart';
import 'edit_product_screen.dart';
import 'user_product_tile.dart';

class UserProductsScreen extends StatelessWidget {
  static const String routeName = '/user_products_screen';

  @override
  Widget build(BuildContext context) {
    final _userProducts = Provider.of<Products>(context);

    return Scaffold(
      appBar: CustomAppBar(context, 'Your Products'),
      drawer: AppDrawer('Your Products'),
      body: BuildProductList(_userProducts),
    );
  }

  PreferredSizeWidget CustomAppBar(context, title) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(fontFamily: 'Merriweather'),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: Layout.SPACING / 2),
          child: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: 'add');
            },
            icon: Icon(Icons.note_add),
          ),
        ),
      ],
    );
  }

  Widget BuildProductList(userProducts) {
    return Padding(
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
    );
  }
}
