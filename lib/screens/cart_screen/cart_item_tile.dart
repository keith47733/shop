import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart.dart';
import '../../../styles/layout.dart';

class CartItemTile extends StatelessWidget {
  final String cartItemId;
  final String productId;
  final String title;
  final double price;
  final int quantity;

  CartItemTile({
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
      left: Layout.SPACING / 2,
      right: Layout.SPACING / 2,
      bottom: 0,
    );

    return Padding(
      padding: itemTileMargins,
      // Can add a confirmDismiss: (direction) {} argument to Dismissable widget. The function must return a bool (true/false).
      child: Dismissible(
        key: ValueKey(cartItemId),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          // A dialog can be shown anywhere, so it's not tied to a Scaffold.
          return showDialog(
            // showDialog requires a context. context will look up the tree for the first context provided. In this case, the context provided by the CartItemTile build() method.
            // showDialog return a Future (see below).
            context: context,
            barrierDismissible: false,
            // All builders within a widgets build() method returns a different context, often referred to as 'ctx'. You can use this to return a number of different kinds of dialogs.
            builder: (ctx) => AlertDialog(
              title: Text('Remove Item'),
              content: Text('Are you sure you want to remove the item from your cart?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop(false);
                  },
                  child: Text(
                    'No',
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // showDialog resolves to a value when it is popped.
                    Navigator.of(ctx).pop(true);
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          );
        },
        onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false).removeProduct(productId);
        },
        background: Container(
          padding: const EdgeInsets.only(right: Layout.SPACING * 1.5),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Layout.RADIUS),
            color: Theme.of(context).colorScheme.errorContainer,
          ),
          child: Icon(
            Icons.delete,
            size: Layout.ICONSIZE,
            color: Theme.of(context).colorScheme.onErrorContainer,
          ),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Layout.RADIUS),
          ),
          tileColor: Theme.of(context).colorScheme.secondaryContainer,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Text(
              '$quantity',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
          ),
          title: Text(title),
          subtitle: Text(
            'x \$${(price)}',
          ),
          trailing: Chip(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            label: Text(
              '\$${(quantity * price).toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
