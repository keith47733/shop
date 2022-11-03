import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/inventory.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail_screen';

  @override
  Widget build(BuildContext context) {
    // Extract arguments from Navigator using ModalRoute.
    // In this case, only the product ID is passed.
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    // Set up the provider.
    // // final productProvider = Provider.of<Products>(context);
    // It is better to hide all getter logic in the provider class.
    // final detailProduct = productProvider.items.firstWhere((product) => product.id == productId);
    // Now, based on the product ID, we can use a provider method to find matching
    // product.
    // // final detailProduct = productProvider.findProductbyId(productId);

    // Can combine setup and get in one statement:
    // // final detailProduct = Provider.of<Products>(context).findProductbyId(productId);

    // Even better, we only want to fetch a product (whereas we want to rebuild
    // the product GridView if a product is added). Assuming a product won't change
    // once this widget is built, it wouldn't matter if a product were added, so we
    // only need to fetch not really listen. So this widget won't rebuild when
    // provider triggers notifyListeners() when listen: is false.
    final detailProduct = Provider.of<Inventory>(context, listen: false).findProductbyId(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(detailProduct.title),
      ),
    );
  }
}
