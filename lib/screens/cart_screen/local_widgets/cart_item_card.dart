import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../styles/layout.dart';
import '../../../providers/cart.dart';

class CartItemCard extends StatelessWidget {
  final String cartItemId;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItemCard({
    required this.cartItemId,
    required this.productId,
    required this.title,
    required this.price,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final itemTileMargins = const EdgeInsets.only(
      top: Layout.SPACING / 2,
      left: Layout.SPACING / 3,
      right: Layout.SPACING / 3,
    );

    // Dismissable makes the CardItemTile dismissable. The Dismissable widget does all the heavy lifting (eg, animations) so a Stateful widget is not required.
    return Dismissible(
      // All key arguments can be of different types. Here, we want to make sure each ID is unique so use ValueKey with the CardItem id passed from CartScreen.
      key: ValueKey(cartItemId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        // Call the removeItem() method from Cart class and pass the productId that was passed to the CardItemDetail from the CartScreen. (Therefore, we don't need to listen for changes.)
        Provider.of<Cart>(context, listen: false).removeCartItem(productId);
      },
      // Background widget is shown behind dissmissable once you start swiping.
      background: Container(
        margin: itemTileMargins,
        padding: const EdgeInsets.only(right: Layout.SPACING * 1.5),
        alignment: Alignment.centerRight,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Layout.ELEVATION),
          color: Theme.of(context).colorScheme.errorContainer,
        ),
        child: Icon(
          Icons.delete,
          size: Layout.ICONSIZE,
          color: Theme.of(context).colorScheme.onErrorContainer,
        ),
      ),
      child: Card(
        elevation: Layout.ELEVATION,
        margin: itemTileMargins,
        color: Theme.of(context).colorScheme.tertiaryContainer,
        child: Padding(
          padding: const EdgeInsets.all(Layout.SPACING / 2),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              child: Text(
                '$quantity',
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onTertiary),
              ),
            ),
            title: Text(title),
            subtitle: Text(
              'x \$${(price)}',
            ),
            trailing: Chip(
              // Want to display the total cost in cart. First we need to setup listener for cart and then best to call logic from the model provider with a getter.
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              label: Text(
                // toString() isn't required with {string interpolation}
                '\$${(quantity * price).toStringAsFixed(2)}',
                style:
                    Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onTertiary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
