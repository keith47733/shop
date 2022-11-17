import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../providers/order_product.dart';
import '../../styles/layout.dart';

class OrderItemTile extends StatefulWidget {
  final int index;
  final OrderProduct orderItem;

  OrderItemTile({
    required this.index,
    required this.orderItem,
  });

  @override
  State<OrderItemTile> createState() => _OrderItemTileState();
}

class _OrderItemTileState extends State<OrderItemTile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Layout.SPACING * 1.5,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(Layout.RADIUS),
        child: ExpansionTile(
          backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          collapsedBackgroundColor: Theme.of(context).colorScheme.secondaryContainer,
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Text(
              '${(widget.index + 1)}',
              style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            ),
          ),
          title: Text(
            '\$${widget.orderItem.amount.toStringAsFixed(2)}',
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
          subtitle: Text(
            DateFormat('MMM d\, yyyy  h:mm a').format(widget.orderItem.orderDate),
            style: TextStyle(color: Theme.of(context).colorScheme.onSecondaryContainer),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: Layout.SPACING,
                left: Layout.SPACING,
                right: Layout.SPACING,
              ),
              child: ListView(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: widget.orderItem.products
                    .map(
                      (product) => Padding(
                        padding: const EdgeInsets.only(bottom: Layout.SPACING),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(product.title, style: Theme.of(context).textTheme.titleMedium),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: Layout.SPACING),
                              child: Text('${product.quantity} x \$${product.price}',
                                  style: Theme.of(context).textTheme.titleSmall),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
