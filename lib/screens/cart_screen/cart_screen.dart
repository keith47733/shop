import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/orders.dart';
import '../../styles/layout.dart';
import '../../widgets/my_app_bar.dart';
import '../../widgets/my_app_drawer.dart';
import '../../widgets/my_snack_bar.dart';
import '../orders_screen/orders_screen.dart';
import '../products_screen/products_screen.dart';
import 'cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    final currentCart = Provider.of<Cart>(context, listen: true);

    return Scaffold(
      appBar: MyAppBar('Cart', Icon(Icons.shop), () => _appBarHandler(context)),
      drawer: MyAppDrawer('Cart'),
      body: Padding(
        padding: EdgeInsets.all(Layout.SPACING),
        child: Column(
          children: [
            CartTotalTile(context, currentCart),
            CartItemTiles(context, currentCart),
          ],
        ),
      ),
    );
  }

  void _appBarHandler(context) {
    Navigator.of(context).pushReplacementNamed(ProductsScreen.routeName);
  }

  Widget CartTotalTile(context, currentCart) {
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
                ? OrderButton(currentCart: currentCart)
                : Text(
                    textAlign: TextAlign.center,
                    'Your cart\nis Empty',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          fontFamily: 'Oswald',
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.normal,
                        ),
                  ),
          ],
        ),
      ),
    );
  }

  Widget CartItemTiles(context, currentCart) {
    return Expanded(
      child: ListView.builder(
        itemCount: currentCart.cartItems.length,
        itemBuilder: ((ctx, index) => CartItemTile(
              cartItemId: currentCart.cartItems.values.toList()[index].cartItemId,
              productItemId: currentCart.cartItems.keys.toList()[index],
              title: currentCart.cartItems.values.toList()[index].title,
              price: currentCart.cartItems.values.toList()[index].price,
              quantity: currentCart.cartItems.values.toList()[index].quantity,
            )),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final currentCart;

  const OrderButton({
    required this.currentCart,
  });

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: (widget.currentCart.cartTotal <= 0 || isLoading == true)
            // Flutter automatically disables a button if onPressed: is null.
            ? null
            : () async {
                setState(() {
                  isLoading = true;
                });
                await Provider.of<Orders>(context, listen: false).addOrder(
                  cartProducts: widget.currentCart.cartItems.values.toList(),
                  total: widget.currentCart.cartTotal,
                );
                setState(() {
                  isLoading = false;
                });
                MySnackBar(context, 'Your order has been placed');
                Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
                widget.currentCart.clearCart();
              },
        child: !isLoading
            ? Text(
                textAlign: TextAlign.center,
                'PLACE\nORDER',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: 'Oswald',
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              )
            : const Center(child: CircularProgressIndicator()));
  }
}
