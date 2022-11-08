import 'package:Shop/styles/layout.dart';
import 'package:flutter/material.dart';

class UserProductTile extends StatelessWidget {
  final String title;
  final String imageUrl;
  UserProductTile(this.title, this.imageUrl);

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
          // backgroundImage; takes an ImageProvider such as NetworkImage(), not an image widget such as Image.network(). The ImageProvider just fetches an image - the CircleAvatar takes care of sizing, fit, etc. So you don't add any widget properties to NetworkImage().
          backgroundImage: NetworkImage(imageUrl),
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontFamily: 'Merriweather',
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
				// Note that Row will take all space available in the ListTile and trailing: does not constrain its size.
        trailing: FittedBox(
          child: Row(
            children: [
              IconButton(
                onPressed: () {},
                color: Theme.of(context).colorScheme.onPrimaryContainer,
                icon: Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {},
								color: Theme.of(context).colorScheme.onPrimaryContainer,
                icon: Icon(Icons.delete),
              )
            ],
          ),
        ),
      ),
    );
  }
}
