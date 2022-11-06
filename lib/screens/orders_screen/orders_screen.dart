import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orders.dart';
import '../../styles/layout.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_drawer.dart';
import 'order_item_card.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders_screen';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: CustomAppBar(context, 'Orders'),
      drawer: AppDrawer('Orders'),
      body: orders.isOrders()
          ? OrdersList(orders)
          : Center(
              child: Text(
                'You haven\'t placed any orders yet.',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
    );
  }

  Widget OrdersList(orders) {
    return SingleChildScrollView(
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
            itemCount: orders.order.length,
            itemBuilder: ((context, index) {
              return OrderItemCard(
                index: index,
                orderItem: orders.order[index],
              );
            }),
          ),
        ),
      ),
    );
  }
}