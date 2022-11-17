import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/inventory.dart';
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
        contentPadding: const EdgeInsets.symmetric(
          vertical: Layout.SPACING / 1.5,
          horizontal: Layout.SPACING,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Layout.RADIUS),
        ),
        tileColor: Theme.of(context).colorScheme.secondaryContainer,
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.onSecondaryContainer,
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
                onPressed: () async {
                  _deleteProduct(context, productItemId);
                },
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
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text('Remove Product'),
        content: Text('Are you sure you want to remove $title?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: Text(
              'No',
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Provider.of<Inventory>(context, listen: false).deleteProduct(productItemId);
            },
            child: Text('Yes'),
          ),
        ],
      ),
    );
  }
}
