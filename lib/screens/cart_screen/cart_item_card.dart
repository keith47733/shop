import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart.dart';
import '../../../styles/layout.dart';

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

    return Dismissible(
      key: ValueKey(cartItemId),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeCartItem(productId);
      },
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
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
              ),
            ),
            title: Text(title),
            subtitle: Text(
              'x \$${(price)}',
            ),
            trailing: Chip(
              backgroundColor: Theme.of(context).colorScheme.tertiary,
              label: Text(
                '\$${(quantity * price).toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
