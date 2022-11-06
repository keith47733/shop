import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orders.dart';
import '../../styles/layout.dart';
import '../../widgets/app_drawer.dart';
import '../products_overview_screen/products_overview_screen.dart';
import 'order_item_card.dart';

class OrdersScreen extends StatelessWidget {
  // routeName needs to be static so that we can access the variable without instantiating the class/widget screen.
  static const routeName = '/orders_screen';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: Layout.SPACING / 2),
            child: IconButton(
              onPressed: () {
                Layout.showFavourites = false;
                Navigator.of(context).pushReplacementNamed(ProductsOverviewScreen.routeName);
              },
              icon: Icon(Icons.shop),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: OrdersList(orders),
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
            // Don't need () when calling a getter.
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
