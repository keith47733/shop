import 'package:Shop/screens/cart_screen.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart.dart';
import 'providers/inventory.dart';
import 'screens/product_detail_screen.dart';
import 'screens/products_overview_screen.dart';
import 'styles/app_theme.dart';

void main() {
  runApp(MyApp());
}

// STATE is essentially DATA that may change which in turn affects the UI.
// APP_WIDE STATE: Affects the entire app or significant parts of it.
// (eg, User login/authentication, products from database server, etc.)
// WIDGET STATE: Affects only the widget it's in.
// (eg, Loading spinner, form inputs, etc.)

// Flutter recommends using the PROVIDER PACKAGE.
// All state date is stored in a central location, and each widgets can
// "listen" to the provider to fetch data instead of passing through constructors.
// The widget's build() method runs anytime data from the "listener" for that
// widget changes.
// You can have multiple data providers and listeners in the app and in each widget.

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (ColorScheme? lightColorScheme, ColorScheme? darkColorScheme) {
        // The return; in build() gets wrapped with a ChangeNotifierProvider.
        // // return ChangeNotifierProvider(
        // Provides an instance of new/revised data to only the child widgets that
        // are listening with, for exmaple, Provider.of<Inventory>(context);
        // eg, In this case, it won't rebuild MaterialApp.
        // // create: (context) => Inventory(),

        // The builder Provier is preferred b/c this is not part of a list.
        // .value is a little less efficient and may lead to unnecesary rebuilds
        // You can nest ChangeNotifierProviders, but it gets ugly quickly!
        // Use MultiProvider
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (ctx) => Inventory()),
            ChangeNotifierProvider(create: (ctx) => Cart()),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Shop',
            theme: AppTheme.lightTheme(lightColorScheme),
            darkTheme: AppTheme.darkTheme(darkColorScheme),
            home: ProductsOverviewScreen(),
            routes: {
              ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
              CartScreen.routeName: (context) => CartScreen(),
            },
          ),
        );
      },
    );
  }
}
