import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../styles/layout.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';
  @override
  Widget build(BuildContext context) {
    // Could add the listener to just the widget that will be affected. But for this
    // small widget we can put the listener just inside the build() and rebuild the
    // entire CartScreen.
    final currentCart = Provider.of<Cart>(context);
    // This will trigger a rebuild when ANYTHING changes in the Cart object class.
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Layout.SPACING,
          horizontal: Layout.SPACING,
        ),
        child: Column(
          children: [
            Card(
              elevation: Layout.ELEVATION,
              margin: const EdgeInsets.only(
                top: Layout.SPACING / 2,
              ),
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(Layout.SPACING),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Total:',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    // This will put Text on left and Chip/TextButton on the
                    // right by taking up all the remaining space.
                    Spacer(),
                    Chip(
                      // Want to display the total cost in cart. First we need
                      // to setup listener for cart and then best to call
                      // logic from the model provider with a getter.
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      label: Text(
                        // toString() isn't required with {string interpolation}
                        '\$${currentCart.cartTotal.toStringAsFixed(2)}',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(color: Theme.of(context).colorScheme.onSecondary),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: Text(
                        'ORDER NOW',
                        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Layout.SPACING),
            Expanded(
              child: ListView.builder(
                itemCount: currentCart.items.length,
                itemBuilder: ((ctx, index) => CartItemTile(
                      // The Cart class uses a map for variables, so we need to
                      // convert that map to an iterable list using
                      // .values.toList() OR pass an entire CartItem object.
                      cartItemId: currentCart.items.values.toList()[index].id,
                      productId: currentCart.items.keys.toList()[index],
                      title: currentCart.items.values.toList()[index].title,
                      price: currentCart.items.values.toList()[index].price,
                      quantity: currentCart.items.values.toList()[index].quantity,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
