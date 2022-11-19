import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/http_exception.dart';
import '../../providers/inventory.dart';
import '../../styles/layout.dart';
import '../../widgets/my_snack_bar.dart';
import '../../widgets/show_confirm_dialog.dart';
import '../../widgets/show_error_dialog.dart';
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

  Future<void> _deleteProduct(context, productItemId) async {
    final _confirmDelete = await showConfirmDialog(
      context,
      'Remove product',
      'Are you sure you want to remove $title from your inventory?',
    );
    if (_confirmDelete == false) {
      return;
    }
    try {
      await Provider.of<Inventory>(context, listen: false).deleteProduct(productItemId);
      MySnackBar(context, '$title was removed from your inventory');
    } on HttpException catch (httpError) {
      showErrorDialog(
        context,
        'Authentication error',
        'Unable to remove $title from inventory. Please try again later.',
      );
    } catch (error) {
      showErrorDialog(
        context,
        'Server error',
        'Uanble to remove $title from inventory. Please try again later.',
      );
    }
  }
}
