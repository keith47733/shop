import 'package:Shop/widgets/my_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/inventory.dart';
import '../../styles/layout.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = '/product_detail_screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String;
    final detailedProduct = Provider.of<Inventory>(context, listen: false).findProductById(productId);

    return Scaffold(
      appBar: MyAppBar('Product Detail', null, null),
      body: ProductDetails(context, detailedProduct),
    );
  }

  Widget ProductDetails(context, detailedProduct) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.symmetric(
          vertical: Layout.SPACING * 1.5,
          horizontal: Layout.SPACING,
        ),
        padding: const EdgeInsets.symmetric(
          vertical: Layout.SPACING * 1.5,
          horizontal: Layout.SPACING,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Layout.RADIUS),
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.6),
        ),
        child: Column(
          children: <Widget>[
            Text(
              textAlign: TextAlign.center,
              detailedProduct.title.toString().toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: Layout.SPACING * 1.5,
                horizontal: Layout.SPACING,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Layout.RADIUS),
                child: Hero(
                  tag: detailedProduct.productId,
                  child: Image.network(
                    detailedProduct.imageUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Text(
              '\$${detailedProduct.price.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.onBackground,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            SizedBox(height: Layout.SPACING),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: Layout.SPACING),
              child: Text(
                detailedProduct.description,
                style:
                    Theme.of(context).textTheme.titleLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground),
                textAlign: TextAlign.left,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../providers/inventory.dart';
// import '../../styles/layout.dart';

// class ProductDetailScreen extends StatelessWidget {
//   static const routeName = '/product_detail_screen';

//   @override
//   Widget build(BuildContext context) {
//     final productId = ModalRoute.of(context)!.settings.arguments as String;
//     final detailedProduct = Provider.of<Inventory>(context, listen: false).findProductById(productId);

//     return SafeArea(
//       child: Scaffold(
//         // When implementing Slivers, we'll create our own AppBar.
//         // // appBar: MyAppBar('Product Detail', null, null),
//         body: ProductDetails(context, detailedProduct),
//       ),
//     );
//   }

//   Widget ProductDetails(context, detailedProduct) {
//     // In order to implement Slivers, first need to change SingleChildScrollView to CustomScrollView. Slivers are scrollable areas on the screen.
//     return CustomScrollView(
//       slivers: <Widget>[
//         SliverAppBar(
//           collapsedHeight: 80.0,
//           expandedHeight: MediaQuery.of(context).size.height * 0.40,
//           pinned: true,
//           flexibleSpace: FlexibleSpaceBar(
//             expandedTitleScale: 1.0,
//             // centerTitle: true,
//             title: Container(
//               decoration: BoxDecoration(
//                 color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
//                 borderRadius: BorderRadius.circular(Layout.RADIUS),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(Layout.SPACING / 2),
//                 child: Text(
//                   detailedProduct.title,
//                   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                         color: Theme.of(context).colorScheme.onPrimary,
//                         fontFamily: 'Oswald',
//                       ),
//                 ),
//               ),
//             ),
//             background: Hero(
//               tag: detailedProduct.productId,
//               child: Image.network(
//                 detailedProduct.imageUrl,
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//         ),
//         SliverList(
//           delegate: SliverChildListDelegate(
//             [
//               // SizedBox(height: Layout.SPACING),
//               // Text(
//               //   detailedProduct.title,
//               //   style: Theme.of(context).textTheme.titleLarge!.copyWith(
//               //         color: Theme.of(context).colorScheme.onBackground,
//               //         fontFamily: 'Oswald',
//               //       ),
//               //   textAlign: TextAlign.center,
//               // ),
//               SizedBox(height: Layout.SPACING),
//               Text(
//                 '\$${detailedProduct.price.toStringAsFixed(2)}',
//                 style: Theme.of(context).textTheme.titleLarge!.copyWith(
//                       color: Theme.of(context).colorScheme.onBackground,
//                       fontWeight: FontWeight.bold,
//                     ),
//                 textAlign: TextAlign.center,
//               ),
//               SizedBox(height: Layout.SPACING),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: Layout.SPACING * 2),
//                 child: Text(
//                   detailedProduct.description,
//                   style: Theme.of(context)
//                       .textTheme
//                       .titleLarge!
//                       .copyWith(color: Theme.of(context).colorScheme.onBackground),
//                   textAlign: TextAlign.left,
//                   softWrap: true,
//                 ),
//               ),
//               SizedBox(height: 600),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
