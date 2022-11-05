import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products.dart';
import '../../styles/layout.dart';

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
    final detailedProduct = Provider.of<Products>(context, listen: false).findProductbyId(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(detailedProduct.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width,
              width: double.infinity,
              child: Image.network(
                detailedProduct.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: Layout.SPACING),
            Text(
              '\$${detailedProduct.price}',
              style:
                  Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            SizedBox(height: Layout.SPACING),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Layout.SPACING),
              child: Text(
                detailedProduct.description,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onBackground),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
