import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/orders.dart';
import '../../styles/layout.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/app_drawer.dart';
import '../orders_screen/orders_screen.dart';
import 'cart_item_tile.dart';

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
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Layout.RADIUS),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Layout.SPACING / 1.5,
          horizontal: Layout.SPACING,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Total:',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            Spacer(),
            Chip(
              backgroundColor: Theme.of(context).colorScheme.primary,
              label: Text(
                '\$${currentCart.cartTotal.toStringAsFixed(2)}',
                style:
                    Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onPrimary),
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
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  )
                : Text(
                    textAlign: TextAlign.center,
                    'Your cart is\nEmpty',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
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
        itemBuilder: ((ctx, index) => CartItemTile(
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
