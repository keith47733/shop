import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products.dart';
import '../../styles/layout.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail_screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final detailedProduct = Provider.of<Products>(context, listen: false).findProductById(productId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Detail',
          style: TextStyle(fontFamily: 'Merriweather'),
        ),
      ),
      body: ProductDetails(context, detailedProduct),
    );
  }

  Widget ProductDetails(context, detailedProduct) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Layout.SPACING * 2,
          horizontal: Layout.SPACING,
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Layout.RADIUS),
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Layout.SPACING),
            child: Column(
              children: <Widget>[
                Text(
                  detailedProduct.title,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                        fontFamily: 'Merriweather',
                      ),
                ),
                SizedBox(height: Layout.SPACING),
                ClipRRect(
                  borderRadius: BorderRadius.circular(Layout.RADIUS),
                  child: Container(
										height: MediaQuery.of(context).size.width * 0.80,
										width: MediaQuery.of(context).size.width * 0.80,
                    child: Image.network(
                      detailedProduct.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SizedBox(height: Layout.SPACING),
                Text(
                  '\$${detailedProduct.price}',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onBackground),
                ),
                SizedBox(height: Layout.SPACING),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: Layout.SPACING),
                  child: Text(
                    detailedProduct.description,
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge!
                        .copyWith(color: Theme.of(context).colorScheme.onBackground),
                    textAlign: TextAlign.center,
                    softWrap: true,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
