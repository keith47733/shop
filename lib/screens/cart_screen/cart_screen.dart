import 'package:Shop/screens/products_overview_screen/products_overview_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/orders.dart';
import '../../styles/layout.dart';
import '../../widgets/app_drawer.dart';
import '../orders_screen/orders_screen.dart';
import 'cart_item_card.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    // Could add the listener to just the widget that will be affected. But for this small screen we can put the listener just inside the build() and rebuild the entire CartScreen.
    final currentCart = Provider.of<Cart>(context, listen: true);
    // This will trigger of the entire widget screen when anything changes (and the listener is notified) in the Cart object class.

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
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
      body: Padding(
        padding: EdgeInsets.all(Layout.SPACING),
        child: Column(
          children: [
            CartTotalCard(context, currentCart),
            CartItemCards(context, currentCart),
          ],
        ),
      ),
    );
  }

  Widget CartTotalCard(context, currentCart) {
    return Card(
      elevation: Layout.ELEVATION,
      margin: const EdgeInsets.symmetric(vertical: Layout.SPACING / 2),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(Layout.SPACING),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Total:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            // Spacer() will put Text on left and Chip/TextButton on the right by taking up all the remaining space.
            Spacer(),
            Chip(
              // Want to display the total cost in the cart. First we need to setup a listener for the cart and then best to call logic from the model provider with a getter.
              backgroundColor: Theme.of(context).colorScheme.secondary,
              label: Text(
                // toString() isn't required with {string interpolation}
                '\$${currentCart.cartTotal.toStringAsFixed(2)}',
                style:
                    Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
            SizedBox(width: Layout.SPACING),
            currentCart.cartTotal > 0
                ? TextButton(
                    onPressed: () {
                      // We don't want to listen to the class/data provider. We only want access to the data and a method. Provider.of<Orders> allows calling the addOrder() method from the class object. eg, Orders.addOrder().
                      Provider.of<Orders>(context, listen: false).addOrder(
                        // Again, we need to convert the Map of cart items to an iterable List of cart items.
                        cartProducts: currentCart.cartItems.values.toList(),
                        total: currentCart.cartTotal,
                      );
                      Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
                      // currentCart is defined as a listener above. This gives access to data and methods like Orders above, but it also triggers a rebuild for example when the clearCart() method with NotifyListeners() is run (listen: true).
                      currentCart.clearCart();
                    },
                    child: Text(
                      textAlign: TextAlign.center,
                      'Place\nOrder',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  )
                : Text(
                    textAlign: TextAlign.center,
                    'Your cart is\nEmpty',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget CartItemCards(context, currentCart) {
    // Expanded allows an unconstrained ListView to be a child of an unconstrained column.
    return Expanded(
      child: ListView.builder(
        itemCount: currentCart.cartItems.length,
        itemBuilder: ((ctx, index) => CartItemCard(
              // The Cart class uses a Map for variables for demonstration purposes, so we need to convert that map to an iterable List using .values.toList() (probalby better to pass an entire CartItem object).
              cartItemId: currentCart.cartItems.values.toList()[index].cartItemId,
              productId: currentCart.cartItems.keys.toList()[index],
              title: currentCart.cartItems.values.toList()[index].title,
              price: currentCart.cartItems.values.toList()[index].price,
              quantity: currentCart.cartItems.values.toList()[index].quantity,
            )),
      ),
    );
  }
}
