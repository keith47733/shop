import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/cart.dart';
import '../../../styles/layout.dart';
import '../../widgets/my_snack_bar.dart';
import '../../widgets/show_confirm_dialog.dart';

class CartItemTile extends StatelessWidget {
  final String cartItemId;
  final String productItemId;
  final String title;
  final double price;
  final int quantity;

  CartItemTile({
    required this.cartItemId,
    required this.productItemId,
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
      child: Dismissible(
        key: ValueKey(cartItemId),
        direction: DismissDirection.endToStart,
        confirmDismiss: (direction) async {
          return showConfirmDialog(
            context,
            'Remove Product',
            'Are you sure you want to remove $title from your cart?',
          );
        },
        onDismissed: (direction) {
          Provider.of<Cart>(context, listen: false).removeProduct(productItemId);
          MySnackBar(context, '$title removed from cart');
        },
        background: Container(
          padding: const EdgeInsets.only(right: Layout.SPACING * 2),
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Layout.RADIUS),
            color: Theme.of(context).colorScheme.error.withOpacity(0.6),
          ),
          child: Icon(
            Icons.delete,
            size: Layout.ICONSIZE,
            color: Theme.of(context).colorScheme.onError,
          ),
        ),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Layout.RADIUS),
          ),
          tileColor: Theme.of(context).colorScheme.tertiaryContainer,
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
    );
  }
}
