import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/cart.dart';
import '../../providers/orders.dart';
import '../../styles/layout.dart';
import '../../widgets/my_snack_bar.dart';
import '../../widgets/show_error_dialog.dart';
import '../../widgets/sub_appbar.dart';
import '../orders_screen/orders_screen.dart';
import 'cart_item_tile.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart_screen';

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context, listen: true);

    return Scaffold(
      appBar: SubAppbar('Cart', null, null),
      body: Padding(
        padding: EdgeInsets.all(Layout.SPACING * 1.5),
        child: Column(
          children: [
            CartTotalTile(context, cart),
            CartItemTiles(context, cart),
          ],
        ),
      ),
    );
  }

  Widget CartTotalTile(context, cart) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Layout.RADIUS),
        color: Theme.of(context).colorScheme.secondaryContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: Layout.SPACING / 1.5,
          horizontal: Layout.SPACING,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Total:',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontFamily: 'Oswald',
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
            ),
            SizedBox(width: Layout.SPACING),
            Chip(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              label: Text(
                '\$${cart.getCartTotal.toStringAsFixed(2)}',
                style:
                    Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
            Spacer(),
            OrderButton(cart),
          ],
        ),
      ),
    );
  }

  Widget CartItemTiles(context, cart) {
    return Expanded(
      child: ListView.builder(
        itemCount: cart.cartDetails.length,
        itemBuilder: ((ctx, index) => CartItemTile(
              cartItemId: cart.cartDetails.values.toList()[index].cartProductId,
              productItemId: cart.cartDetails.keys.toList()[index],
              title: cart.cartDetails.values.toList()[index].title,
              price: cart.cartDetails.values.toList()[index].price,
              quantity: cart.cartDetails.values.toList()[index].quantity,
            )),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart cart;
  OrderButton(this.cart);

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;

  Future<void> _placeOrder() async {
    try {
      setState(() {
        isLoading = true;
      });
      await Provider.of<Orders>(context, listen: false).addOrder(
        cartProducts: widget.cart.cartDetails.values.toList(),
        total: widget.cart.getCartTotal,
      );
      setState(() {
        isLoading = false;
      });
      MySnackBar(context, 'Your order has been placed');
      widget.cart.clearCart();
      Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      showErrorDialog(context, 'Server error', 'Unable to place your order. Please try again later.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.onSecondaryContainer),
      ),
      onPressed: (widget.cart.getCartTotal <= 0 || isLoading == true) ? null : () => _placeOrder(),
      child: Padding(
        padding: const EdgeInsets.all(Layout.SPACING / 4),
        child: !isLoading
            ? Text(
                textAlign: TextAlign.center,
                (widget.cart.getCartTotal > 0) ? 'PLACE\nORDER' : 'Your cart\nis Empty',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                      fontFamily: 'Oswald',
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
