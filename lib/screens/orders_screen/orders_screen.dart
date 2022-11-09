import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orders.dart';
import '../../styles/layout.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_app_drawer.dart';
import '../products_screen/products_screen.dart';
import 'order_item_tile.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders_screen';

  @override
  Widget build(BuildContext context) {
    final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: MyAppBar('Orders', Icon(Icons.shop), () => _appBarHandler(context)),
      drawer: MyAppDrawer('Orders'),
      body: orders.isOrders()
          ? OrdersList(orders)
          : Padding(
              padding: const EdgeInsets.all(Layout.SPACING * 4),
              child: Center(
                child: Text(
                  'You haven\'t placed any orders yet.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
              ),
            ),
    );
  }

  void _appBarHandler(context) {
    Navigator.of(context).pushReplacementNamed(ProductsScreen.routeName);
  }

  Widget OrdersList(orders) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(
          top: Layout.SPACING,
          left: Layout.SPACING,
          right: Layout.SPACING,
        ),
        child: Column(
          children: [
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: orders.order.length,
              itemBuilder: ((context, index) {
                return OrderItemTile(
                  index: index,
                  orderItem: orders.order[index],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
