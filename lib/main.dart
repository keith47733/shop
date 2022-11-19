import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/inventory.dart';
import 'providers/orders.dart';
import 'screens/auth_screen/auth_screen.dart';
import 'screens/cart_screen/cart_screen.dart';
import 'screens/orders_screen/orders_screen.dart';
import 'screens/product_detail_screen/product_detail_screen.dart';
import 'screens/products_screen/products_screen.dart';
import 'screens/splash_screen/splash_screen.dart';
import 'screens/user_products_screen/edit_product_screen.dart';
import 'screens/user_products_screen/user_products_screen.dart';
import 'styles/app_theme.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (
        ColorScheme? lightColorScheme,
        ColorScheme? darkColorScheme,
      ) {
        return MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (ctx) => Auth()),
            ChangeNotifierProxyProvider<Auth, Inventory>(
              create: (ctx) => Inventory(
                Provider.of<Auth>(ctx, listen: false).getUid,
                Provider.of<Auth>(ctx, listen: false).getToken,
                Provider.of<Auth>(ctx, listen: false).getExpiryDate,
              ),
              update: (ctx, auth, inventory) => Inventory(
                auth.getUid,
                auth.getToken,
                auth.getExpiryDate,
              ),
            ),
            ChangeNotifierProvider(create: (ctx) => Cart()),
            ChangeNotifierProxyProvider<Auth, Orders>(
              create: (ctx) => Orders(
                Provider.of<Auth>(ctx, listen: false).getUid,
                Provider.of<Auth>(ctx, listen: false).getToken,
                Provider.of<Auth>(ctx, listen: false).getExpiryDate,
              ),
              update: (ctx, auth, _) => Orders(
                auth.getUid,
                auth.getToken,
                auth.getExpiryDate,
              ),
            ),
          ],
          child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Bitches Be Shopping',
              theme: AppTheme.lightTheme(lightColorScheme),
              darkTheme: AppTheme.darkTheme(darkColorScheme),
              home: FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authSnapshot) {
                  if (authSnapshot.connectionState == ConnectionState.waiting) {
                    return SplashScreen();
                  }
                  if (auth.isAuth) {
                    return ProductsScreen();
                  } else {
                    return AuthScreen();
                  }
                },
              ),
              routes: {
                AuthScreen.routeName: (ctx) => AuthScreen(),
                ProductsScreen.routeName: (ctx) => ProductsScreen(),
                ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
                CartScreen.routeName: (ctx) => CartScreen(),
                OrdersScreen.routeName: (ctx) => OrdersScreen(),
                UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
                EditProductScreen.routeName: (ctx) => EditProductScreen(),
              },
            ),
          ),
        );
      },
    );
  }
}
