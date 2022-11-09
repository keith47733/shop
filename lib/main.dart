import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/products.dart';
import 'screens/cart_screen/cart_screen.dart';
import 'screens/orders_screen/orders_screen.dart';
import 'screens/product_detail_screen/product_detail_screen.dart';
import 'screens/products_screen/products_screen.dart';
import 'screens/user_products_screen/edit_product_screen.dart';
import 'screens/user_products_screen/user_products_screen.dart';
import 'styles/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final screenWidth = WidgetsBinding.instance.window.physicalSize.width;
    return DynamicColorBuilder(
      builder: (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (ctx) => Products()),
            ChangeNotifierProvider(create: (ctx) => Cart()),
            ChangeNotifierProvider(create: (ctx) => Orders()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop',
            theme: AppTheme.lightTheme(lightColorScheme),
            // .copyWith(
            //   textTheme: Theme.of(context).textTheme.apply(
            //         // fontSizeFactor: 1.0,
            //         fontSizeFactor: screenWidth / 1080,
            //       ),
            // ),
            darkTheme: AppTheme.darkTheme(darkColorScheme),
            home: ProductsScreen(),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
							UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
							EditProductScreen.routeName: (ctx) => EditProductScreen(),
            },
          ),
        );
      },
    );
  }
}
