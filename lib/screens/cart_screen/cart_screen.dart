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
        padding: EdgeInsets.all(Layout.SPACING * 1.5),
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
                '\$${currentCart.cartTotal.toStringAsFixed(2)}',
                style:
                    Theme.of(context).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSecondary),
              ),
            ),
            Spacer(),
            OrderButton(currentCart),
          ],
        ),
      ),
    );
  }

  Widget CartItemTiles(context, currentCart) {
    return Expanded(
      child: ListView.builder(
        itemCount: currentCart.cartDetails.length,
        itemBuilder: ((ctx, index) => CartItemTile(
              cartItemId: currentCart.cartDetails.values.toList()[index].cartProductId,
              productItemId: currentCart.cartDetails.keys.toList()[index],
              title: currentCart.cartDetails.values.toList()[index].title,
              price: currentCart.cartDetails.values.toList()[index].price,
              quantity: currentCart.cartDetails.values.toList()[index].quantity,
            )),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  final Cart currentCart;
  OrderButton(this.currentCart);

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(width: 1.0, color: Theme.of(context).colorScheme.onSecondaryContainer),
      ),
      onPressed: (widget.currentCart.cartTotal <= 0 || isLoading == true)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                cartProducts: widget.currentCart.cartDetails.values.toList(),
                total: widget.currentCart.cartTotal,
              );
              setState(() {
                isLoading = false;
              });
              MySnackBar(context, 'Your order has been placed');
              widget.currentCart.clearCart();
              Navigator.of(context).pushReplacementNamed(OrdersScreen.routeName);
            },
      child: Padding(
          padding: const EdgeInsets.all(Layout.SPACING / 4),
          child: !isLoading
              ? Text(
                  textAlign: TextAlign.center,
                  (widget.currentCart.cartTotal > 0) ? 'PLACE\nORDER' : 'Your cart\nis Empty',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontFamily: 'Oswald',
                        color: Theme.of(context).colorScheme.onSecondaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                )
              : const Center(child: CircularProgressIndicator())),
    );
  }
}
