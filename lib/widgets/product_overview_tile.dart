import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import '../styles/layout.dart';

// Interestingly, we don't need a Stateful widget when using Provider/Consumer.

class ProductOverviewTile extends StatelessWidget {
  // final String id;
  // final String title;
  // final double price;
  // final String imageUrl;

  // ProductOverviewTile(this.id, this.title, this.price, this.imageUrl);

  // It seems the {} indicate named arguments.
  // If the argument is not requried, then it could be null so you have to make the
  // variables above nullable with ?.

  @override
  Widget build(BuildContext context) {
    // This sets a variables value and marks it as a listener to <Product>.
    // // final currentProduct = Provider.of<Product>(context);
    // Another approach is to use Provider to fetch data (listen: false)
    // and wrap individual widgets with Consumer<Product>. The major advantage is
    // ONLY the widget(s) wrapped in Consumer listener will rebuild, not the entire
    // widget build().
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    // A GridTile for a GridView is analogous to a ListTile for a ListView.
    return ClipRRect(
      borderRadius: BorderRadius.circular(Layout.RADIUS),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.id,
          );
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailScreen(gridTileProduct)));
        },
        child: GridTile(
          header: Padding(
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
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(color: Theme.of(context).colorScheme.onSecondary),
                  ),
                ),
              ),
            ),
          ),
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
            leading: Consumer<Product>(
              // Interesting...you need to use a different variable than the "context"
              // context required for Theme below. Use a different "ctx" in the
							// Consumer builder. You can specify a child in the builder and a child:
							// argument for aspects of the widget that don't need to be rebuilt.
              // (If a static child is not required, use '_')
              builder: (ctx, currentProduct, _) => IconButton(
                onPressed: () {
                  // This calls the toggleFavorite() method which in turn notifies
                  // listeners.
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
              onPressed: () => cart.addItem(
                productId: product.id,
                title: product.title,
                price: product.price,
              ),
              icon: Icon(
                Icons.shopping_cart,
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
