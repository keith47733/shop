import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/orders.dart';
import '../../styles/layout.dart';
import '../../widgets/app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../orders_screen/orders_screen.dart';
import 'cart_item_card.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    final currentCart = Provider.of<Cart>(context, listen: true);

    return Scaffold(
      appBar: CustomAppBar(context, 'Cart'),
      drawer: AppDrawer('Cart'),
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
            Spacer(),
            Chip(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              label: Text(
                '\$${currentCart.cartTotal.toStringAsFixed(2)}',
                style:
                    Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
            SizedBox(width: Layout.SPACING),
            currentCart.cartTotal > 0
                ? TextButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false).addOrder(
                        cartProducts: currentCart.cartItems.values.toList(),
                        total: currentCart.cartTotal,
                      );
                      Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
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
    return Expanded(
      child: ListView.builder(
        itemCount: currentCart.cartItems.length,
        itemBuilder: ((ctx, index) => CartItemCard(
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