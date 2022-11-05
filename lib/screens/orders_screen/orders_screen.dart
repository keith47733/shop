import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orders.dart';
import '../../styles/layout.dart';
import '../../widgets/app_drawer.dart';
import 'order_item_card.dart';

class OrdersScreen extends StatelessWidget {
  // Needs to be static so that we can access the variable without instantiating the class/widget screen.
  static const routeName = '/orders_screen';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(title: Text('Orders')),
      drawer: AppDrawer(),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.only(
              top: Layout.SPACING,
              left: Layout.SPACING,
              right: Layout.SPACING,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              // Don't need () when calling a getter.
              itemCount: orders.order.length,
              // shrinkWrap: true,
              itemBuilder: ((context, index) {
                return OrderItemCard(index, orders.order[index]);
              }),
            ),
          ),
        ),
      ),
    );
  }
}
