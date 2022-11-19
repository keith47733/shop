import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/inventory.dart';
import '../../styles/layout.dart';
import '../../widgets/sub_appbar.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail_screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final detailedProduct = Provider.of<Inventory>(context, listen: false).findProductById(productId);

    return Scaffold(
			appBar: SubAppbar(detailedProduct.title, null, null),
      body: ProductDetails(context, detailedProduct),
    );
  }

  Widget ProductDetails(context, detailedProduct) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Layout.SPACING * 1.5),
        child: Column(
          children: <Widget>[
            Hero(
              tag: detailedProduct.productId,
              child: Image.network(
                detailedProduct.imageUrl,
                height: MediaQuery.of(context).size.width * 0.80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: Layout.SPACING),
            Text(
              '\$${detailedProduct.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: Layout.SPACING),
            Text(
              detailedProduct.description,
              style:
                  Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground),
              textAlign: TextAlign.left,
              softWrap: true,
            ),
          ],
        ),
      ),
    );
  }
}
