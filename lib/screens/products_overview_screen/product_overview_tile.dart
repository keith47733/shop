import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart.dart';
import '../../../providers/product_item.dart';
import '../../../styles/layout.dart';
import '../product_detail_screen/product_detail_screen.dart';

// Interestingly, we don't need a Stateful widget when using Provider/Consumer. They will rebuild only their children in a Stateless widget!

class ProductOverviewTile extends StatelessWidget {
  // final String id;
  // final String title;
  // final double price;
  // final String imageUrl;

  // You either have to make the variables above nullable. eg, final String? id.
  // // ProductOverviewTile(this.id, this.title, this.price, this.imageUrl);
  // Or make them required variables to ensure they can't be null by putting them {} with the 'required' keyword. Note the {} also turns them into named arguments when the widget/class is instantiated.
  // // ProductOverviewTile({required this.id, ...});

  @override
  Widget build(BuildContext context) {
    // This basically instantiates a Product class object. The default is listen: true,
    // // final currentProduct = Provider.of<Product>(context);
    // Another approach is to use the Provider to only fetch data (listen: false) and wrap individual widgets with Consumer<Product> for rebuilds. The major advantage is ONLY the widget(s) wrapped in Consumer listener will rebuild, not the entire widget build().
    final product = Provider.of<ProductItem>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(Layout.RADIUS),
      child: GestureDetector(
        onTap: () {
          // arguments: allows data to be passed from one screen to another through the Navigator where requried (most data will be accessed through Providers though).
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.productItemId,
          );
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailScreen(gridTileProduct)));
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
        // Interesting...you need to use a different variable than the "context" context required for Theme below. Use a different "ctx" in the Consumer builder. You can specify a child in the builder and a child: argument for aspects of the widget that don't need to be rebuilt. (If a static child is not required, you can use '_')
        builder: (ctx, currentProduct, _) => IconButton(
          onPressed: () {
            // This calls the Prodcut class toggleFavorite() method. The method  notifies listeners when it is done. Any listeners/consumers will then rebuild their children.
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
