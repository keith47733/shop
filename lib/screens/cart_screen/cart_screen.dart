import '../../providers/orders.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';

import '../../styles/layout.dart';
import '../orders_screen/orders_screen.dart';
import 'local_widgets/cart_item_card.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';
  @override
  Widget build(BuildContext context) {
    // Could add the listener to just the widget that will be affected. But for this
    // small widget we can put the listener just inside the build() and rebuild the
    // entire CartScreen.
    final currentCart = Provider.of<Cart>(context, listen: true);
    // This will trigger a rebuild when ANYTHING changes in the Cart object class.
    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Padding(
        padding: Layout.MARGINS_ALL,
        child: Column(
          children: [
            _buildCartTotalCard(context, currentCart),
            _buildCartItemCards(context, currentCart),
          ],
        ),
      ),
    );
  }

  Widget _buildCartTotalCard(context, currentCart) {
    return Card(
      elevation: Layout.ELEVATION,
      margin: const EdgeInsets.symmetric(vertical: Layout.SPACING / 2),
      color: Theme.of(context).colorScheme.secondaryContainer,
      child: Padding(
        padding: Layout.MARGINS_ALL,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Total:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            // This will put Text on left and Chip/TextButton on the right by taking up all the remaining space.
            Spacer(),
            Chip(
              // Want to display the total cost in cart. First we need
              // to setup listener for cart and then best to call
              // logic from the model provider with a getter.
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
                      // We don't want to listen to the class/data provider. We only want access to the data and a method.
                      // Provider.of<Orders> is essentially calling the class object. eg, Orders.addOrder().
                      Provider.of<Orders>(context, listen: false).addOrder(
                        // Again, we need to convert the map of cart items to a list of cart items.
                        cartProducts: currentCart.cartItems.values.toList(),
                        total: currentCart.cartTotal,
                      );
                      Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
                      // currentCart is defined as a listener above. This givess access to data and methods like Orders above, but it also triggers a rebuild for example when the clearCart() method is run (listen: true).
                      currentCart.clearCart();
                    },
                    child: Text(
                      textAlign: TextAlign.right,
                      'Place\nOrder',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  )
                : Text(
                    textAlign: TextAlign.right,
                    'Cart is\nEmpty',
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

  Widget _buildCartItemCards(context, currentCart) {
    return Expanded(
      child: ListView.builder(
        itemCount: currentCart.cartItems.length,
        itemBuilder: ((ctx, index) => CartItemCard(
              // The Cart class uses a map for variables, so we need to convert that map to an iterable list using .values.toList() OR pass an entire CartItem object.
              cartItemId: currentCart.cartItems.values.toList()[index].id,
              productId: currentCart.cartItems.keys.toList()[index],
              title: currentCart.cartItems.values.toList()[index].title,
              price: currentCart.cartItems.values.toList()[index].price,
              quantity: currentCart.cartItems.values.toList()[index].quantity,
            )),
      ),
    );
  }
}
