import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orders.dart';
import '../../styles/layout.dart';
import '../../widgets/error_message.dart';
import '../../widgets/loading_spinner.dart';
import '../../widgets/main_app_bar.dart';
import '../../widgets/my_app_drawer.dart';
import 'order_item_tile.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
			appBar: MainAppBar(context, 'Orders'),
      drawer: MyAppDrawer('Orders'),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (ctx1, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          }
          if (snapshot.error != null) {
            return ErrorMessage(ctx1);
          }
          return Consumer<Orders>(
            builder: (ctx2, orders, child) {
              if (!orders.isOrders()) {
                return NoOrdersMessage(ctx1);
              } else {
                return OrdersList(orders);
              }
            },
          );
        },
      ),
    );
  }
}

Widget NoOrdersMessage(context) {
  return Padding(
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
  );
}

Widget OrdersList(orders) {
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.only(
        top: Layout.SPACING * 1.5,
        left: Layout.SPACING * 1.5,
        right: Layout.SPACING * 1.5,
      ),
      child: Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: orders.orderDetails.length,
            itemBuilder: ((context, index) {
              return OrderItemTile(
                index: index,
                orderItem: orders.orderDetails[index],
              );
            }),
          ),
        ],
      ),
    ),
  );
}
