import 'package:Shop/screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.dart';
import '../styles/layout.dart';

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
    final currentProduct = Provider.of<Product>(context);
    // A GridTile for a GridView is analogous to a ListTile for a ListView.
    return ClipRRect(
      borderRadius: BorderRadius.circular(Layout.RADIUS),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: currentProduct.id,
          );
          // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailScreen(gridTileProduct)));
        },
        child: GridTile(
          header: Padding(
            padding: const EdgeInsets.all(Layout.SPACING),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(Layout.RADIUS),
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
              ),
              child: Padding(
                padding: const EdgeInsets.all(Layout.SPACING / 2),
                child: Text(
                  currentProduct.title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge!
                      .copyWith(color: Theme.of(context).colorScheme.onSecondary),
                ),
              ),
            ),
          ),
          child: Image.network(
            currentProduct.imageUrl,
            fit: BoxFit.cover,
          ),
          footer: GridTileBar(
            backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
            leading: IconButton(
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
            title: Text(
              '\$${currentProduct.price.toString()}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            trailing: IconButton(
              onPressed: () {},
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
