import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products.dart';
import '../../styles/layout.dart';

class ProductDetailScreen extends StatelessWidget {
  // You can name the widget screens route here, but don't forget to register it in routes{} in main.dart.
  static const routeName = '/product_detail_screen';

  @override
  Widget build(BuildContext context) {
    // Extract argument(s) from the screen that pushed this screen with the Navigator using ModalRoute. In this case, only the productId is passed and extracted.
    final productId = ModalRoute.of(context)!.settings.arguments as String;

    // Set up the Products class listener:
    // // final productProvider = Provider.of<Products>(context);
    // It is better to hide all getter logic in the provider class.
    // // final detailProduct = productProvider.items.firstWhere((product) => product.id == productId);
    // Now, based on the productId, we can use a provider method to find a matching product in the Product class.
    // // final detailProduct = productProvider.findProductbyId(productId);

    // Can combine setup and get in one statement:
    // // final detailProduct = Provider.of<Products>(context).findProductbyId(productId);

    // Even better, we only want to fetch a single Product (whereas in the OverviewScreen we want to rebuild the product GridView if a product is added/deleted). Assuming a product won't change once this widget is built, it wouldn't matter if a product were added, so we only need to fetch not really listen. So this widget won't rebuild when provider triggers notifyListeners() when listen: is false.
    final detailedProduct = Provider.of<Products>(context, listen: false).findProductbyId(productId);

    return Scaffold(
      appBar: AppBar(title: Text('Product Detail')),
      body: ProductDetails(context, detailedProduct),
    );
  }

  Widget ProductDetails(context, detailedProduct) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Layout.SPACING),
        child: Column(
          children: <Widget>[
            Text(
              detailedProduct.title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground),
            ),
            SizedBox(height: Layout.SPACING),
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
