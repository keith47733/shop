import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart.dart';
import '../../../styles/layout.dart';
import '../../models/http_exception.dart';
import '../../providers/auth.dart';
import '../../providers/product.dart';
import '../../widgets/my_snack_bar.dart';
import '../../widgets/show_error_dialog.dart';
import '../product_detail_screen/product_detail_screen.dart';

class ProductTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);

    return ClipRRect(
      borderRadius: BorderRadius.circular(Layout.RADIUS),
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            ProductDetailScreen.routeName,
            arguments: product.productId,
          );
        },
        child: GridTile(
          header: GridTileHeader(context, product),
          child: Hero(
            tag: product.productId,
            child: FadeInImage(
              placeholder: AssetImage('assets/images/product_placeholder.png'),
              image: NetworkImage(product.imageUrl),
              fit: BoxFit.scaleDown,
            ),
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
            color: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
          ),
          child: Padding(
            padding: const EdgeInsets.all(Layout.SPACING / 2),
            child: Text(
              '\$${product.price.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
										fontFamily: 'Oswald',
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleFavourite(context, product) async {
    try {
      await product.toggleFavourite(
        context,
        Provider.of<Auth>(context, listen: false).getUid,
        Provider.of<Auth>(context, listen: false).getToken,
      );
      if (product.isFavourite == true) {
        MySnackBar(context, '${product.title} added to your favourites');
      } else {
        MySnackBar(context, '${product.title} removed from your favourites');
      }
    } on HttpException catch (httpError) {
      showErrorDialog(context, 'Authentication error', 'Unable to update favourites. Please try again later.');
    } catch (error) {
			showErrorDialog(context, 'Server error', 'Unable to update favourites. Please try again later.');
    }
  }

  Widget GridTileFooter(context, product, cart) {
    return GridTileBar(
      backgroundColor: Theme.of(context).colorScheme.secondary.withOpacity(0.7),
      leading: Consumer<Product>(
        builder: (ctx, product, _) => IconButton(
          onPressed: () => _toggleFavourite(context, product),
          icon: product.isFavourite
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
              fontFamily: 'Oswald',
            ),
        textAlign: TextAlign.center,
      ),
      trailing: IconButton(
        onPressed: () {
          cart.addCartItem(product.productId, product.title, product.price);
          MySnackBar(context, '${product.title} added to cart');
        },
        icon: Icon(
          Icons.shopping_cart,
          color: Theme.of(context).colorScheme.onSecondary,
        ),
      ),
    );
  }
}
