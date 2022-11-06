import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../providers/order_item.dart';
import '../../styles/layout.dart';

// Will need a Stateful widget for expandable ListTiles.
class OrderItemCard extends StatefulWidget {
  final int index;
  final OrderItem orderItem;

  OrderItemCard({required this.index, required this.orderItem});

  @override
  State<OrderItemCard> createState() => _OrderItemCardState();
}

class _OrderItemCardState extends State<OrderItemCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: Layout.SPACING,
      ),
      child: Card(
        color: Theme.of(context).colorScheme.secondaryContainer,
        child: Column(
          children: [
            ExpansionTile(
              backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              collapsedBackgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
              leading: CircleAvatar(
                backgroundColor: Theme.of(context).colorScheme.secondary,
                child: Text(
                  '${(widget.index + 1)}',
                  style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                ),
              ),
              title: Text(
                '\$${widget.orderItem.amount.toStringAsFixed(2)}',
                style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer),
              ),
              subtitle: Text(
                DateFormat('MMM d\, yyyy').format(widget.orderItem.orderDate),
                style: TextStyle(color: Theme.of(context).colorScheme.onTertiaryContainer),
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
                                Text(product.title, style: Theme.of(context).textTheme.titleMedium),
                                Text('${product.quantity} x \$${product.price}',
                                    style: Theme.of(context).textTheme.titleSmall),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ],
            ),
            // ListTile(
            //   leading: CircleAvatar(
            //     backgroundColor: Theme.of(context).colorScheme.secondary,
            //     child: Text('${(widget.index + 1)}'),
            //   ),
            //   title: Text('\$${widget.orderItem.amount.toStringAsFixed(2)}'),
            //   subtitle: Text(DateFormat('MMM d\, yyyy').format(widget.orderItem.orderDate)),
            //   trailing: IconButton(
            //     onPressed: () {
            //       setState(() {
            //         _expanded = !_expanded;
            //       });
            //     },
            //     icon: _expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
            //   ),
            // ),
            // // Dart provides an in List<Widget> if function that returns a child if true or nothing if false.
            // if (_expanded)
            //   Container(
            //     // The min() function is provided by Dart and takes the smaller of the two arguements.
            //     padding: const EdgeInsets.only(top: Layout.SPACING, left: Layout.SPACING, right: Layout.SPACING),
            //     height: min(100.0 + widget.orderItem.products.length * 20.0, 180.0),
            //     child: ListView(
            // 		shrinkWrap: true,
            //   	physics: NeverScrollableScrollPhysics(),
            //       children: widget.orderItem.products
            //           .map(
            //             (product) => Padding(
            //               padding: const EdgeInsets.only(bottom: Layout.SPACING),
            //               child: Row(
            //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //                 children: [
            //                   Text(product.title, style: Theme.of(context).textTheme.titleMedium),
            //                   Text('${product.quantity} x \$${product.price}',
            //                       style: Theme.of(context).textTheme.titleSmall),
            //                 ],
            //               ),
            //             ),
            //           )
            //           .toList(),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }
}
