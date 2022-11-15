import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/orders.dart';
import '../../styles/layout.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_app_drawer.dart';
import '../products_screen/products_screen.dart';
import 'order_item_tile.dart';

// OrdersScreen was chaged to a SatefulWidget only because we want to use initState() below to load the Orders once when screen is built (initState() is not available for a Stateless Widget). Fetching the orders data in the widget build() would fetch the orders everytime the state changes. (In this case, it might even enter an infinite loop because we set _isLoading = true/false when the data is loaded).
class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders_screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
	// This is the best way to obtain the Orders data so the widget can be Stateful and respond to rebuilds without re-fetching the data.
	// Make _ordersFuture nullable
	Future? _ordersFuture;

	Future _obtainOrdersFuture () {
		return Provider.of<Orders>(context, listen: false).fetchAllOrders();
	}

	@override
	void initState() {
		super.initState();
		_ordersFuture = _obtainOrdersFuture();
	}

  @override
  Widget build(BuildContext context) {
    print('BUILDING ENTIRE WIDGET');
    // This sets up a listener but doesn't fetch the orders.
    // When using a FutureBuilder, you must set up Consumer around part of UI that depends on the <Orders> data.
    // // final orders = Provider.of<Orders>(context);
    return Scaffold(
      appBar: MyAppBar('Orders', Icon(Icons.shop), () => _appBarHandler(context)),
      drawer: MyAppDrawer('Orders'),
      // Instead of Stateful/initState(), can use a FutureBuilder widget. The widget takes a Future and automatically starts listening to it (like adding the .then() and catchError() for you). Also takes a builder: to biuld different contents based on state of the Future (ie, what the Future returns).
      // Have to be careful though. Because we set up a listener above, once we fetchAllOrders() it will notify listeners. The listener above will then rebuild the widget and the Consumer will fetchAllOrders() again - remove the listener.
			// FutureBuilder is preferred. Allows greater flexibility for the body, using a function with IF statements and doesn't rebuild the whole widget screen, only the Consumer part.
			// Note, in addition to above, ANYTHING that causes the widget screen to rebuild (setState, of(context), etc) will cause an infinite loop. In this case it won't happen, but there is a better way to get the future:
			// The solution is to convert the widget back to Stateful and fetch the future in initState().
      body: FutureBuilder(
        future: _ordersFuture,
        builder: ((context, dataSnapshot) {
          // dataSnapshot is an AsyncSnapshot object with build in properties. It will never be null.
          if (dataSnapshot.connectionState == ConnectionState.waiting) {
            print('CONNECTIONSTATE IS WAITING');
            return const Center(child: CircularProgressIndicator());
          }
          print('HAVE NOW RETURNED DATASNAPSHOT');
          if (dataSnapshot.error != null) {
            print('DATASNAPSHOT RETURNED AN ERROR');
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
          print('DATASNAPSHOT IS NOT AN ERROR - RETURN THE CONSUMER');
          // Remember the Consumer<> requires a child even if it's null.
          return Consumer<Orders>(builder: (ctx, orders, child) {
            print('NOW INSIDE CONSUMER');
            if (!orders.isOrders()) {
              print('RETRIEVED ORDERS - BUT NO ORDERS ON SERVER');
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
            print('RETRIEVED ORDERS - CALL ORDERSLIST TO BUILD LISTVIEW');

            return OrdersList(orders);
          });
        }),
      ),
    );
  }
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
