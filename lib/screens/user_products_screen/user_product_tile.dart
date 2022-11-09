import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/products.dart';
import '../../styles/layout.dart';
import 'edit_product_screen.dart';

class UserProductTile extends StatelessWidget {
  final String productItemId;
  final String title;
  final String imageUrl;

  UserProductTile(this.productItemId, this.title, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: Layout.SPACING / 2,
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(Layout.SPACING / 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Layout.RADIUS),
        ),
        tileColor: Theme.of(context).colorScheme.primaryContainer,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily: 'Merriweather',
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
        trailing: FittedBox(
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(EditProductScreen.routeName, arguments: productItemId);
                },
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                icon: Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () => _deleteProduct(context, productItemId),
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                icon: Icon(Icons.delete),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _deleteProduct(context, productItemId) async {
    bool _deleteProduct = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Remove Product'),
        content: Text('Are you sure you want to remove this product?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteProduct = false;
            },
            child: Text(
              'No',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _deleteProduct = true;
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
    if (_deleteProduct) {
      Provider.of<Products>(context, listen: false).deleteProduct(productItemId);
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Product successfully deleted',
          ),
          duration: Duration(seconds: Layout.SNACK_BAR_DURATION),
        ),
      );
    }
  }
}
