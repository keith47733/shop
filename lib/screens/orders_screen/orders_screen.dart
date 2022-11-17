import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orders.dart';
import '../../styles/layout.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_app_drawer.dart';
import '../products_screen/products_screen.dart';
import 'order_item_tile.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders_screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? _ordersFuture;

  Future _obtainOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).fetchOrders();
  }

  @override
  void initState() {
    super.initState();
    _ordersFuture = _obtainOrdersFuture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar('Orders', Icon(Icons.shop), () => _appBarHandler(context)),
      drawer: MyAppDrawer('Orders'),
      body: FutureBuilder(
        future: _ordersFuture,
        builder: ((context, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            return LoadingSpinner();
          }
          if (dataSnapshot.error != null) {
            return ErrorMessage(context);
          }
          return Consumer<Orders>(
            builder: (ctx, orders, child) {
              if (!orders.isOrders()) {
                return NoOrdersMessage(context);
              } else {
                return OrdersList(orders);
              }
            },
          );
        }),
      ),
    );
  }
}

void _appBarHandler(context) {
  Navigator.of(context).pushReplacementNamed(ProductsScreen.routeName);
}

Widget LoadingSpinner() {
  return const Center(child: CircularProgressIndicator());
}

Widget ErrorMessage(context) {
  return Padding(
    padding: const EdgeInsets.all(Layout.SPACING * 4),
    child: Center(
      child: Text(
        'An error has occurred.',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              color: Theme.of(context).colorScheme.onBackground,
            ),
      ),
    ),
  );
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
