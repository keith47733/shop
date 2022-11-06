import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart.dart';
import '../../../providers/product_item.dart';
import '../../../styles/layout.dart';
import '../product_detail_screen/product_detail_screen.dart';

class ProductOverviewTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductItem>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(Layout.RADIUS),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.productItemId,
          );
        },
        child: GridTile(
          header: GridTileHeader(context, product),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileFooter(context, product, cart),
        ),
      ),
    );
  }

  Widget GridTileHeader(context, product) {
    return Padding(
      padding: const EdgeInsets.all(Layout.SPACING),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.topLeft,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Layout.RADIUS),
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Layout.SPACING / 2),
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondary),
            ),
          ),
        ),
      ),
    );
  }

  Widget GridTileFooter(context, product, cart) {
    return GridTileBar(
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
      leading: Consumer<ProductItem>(
        builder: (ctx, currentProduct, _) => IconButton(
          onPressed: () {
            currentProduct.toggleFavourite();
          },
          icon: currentProduct.isFavourite
              ? Icon(
                  Icons.favorite,
                  color: Theme.of(context).colorScheme.onSecondary,
                )
              : Icon(
                  Icons.favorite_border,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
        ),
      ),
      title: Text(
        product.title,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onSecondary,
            ),
        textAlign: TextAlign.center,
      ),
      trailing: IconButton(
        onPressed: () => cart.addCartItem(
          productId: product.productItemId,
          title: product.title,
          price: product.price,
        ),
        icon: Icon(
          Icons.shopping_cart,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }
}
