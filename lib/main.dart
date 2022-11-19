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
  // await WidgetsFlutterBinding.ensureInitialized();
  // final _screenWidth = WidgetsBinding.instance.window.physicalSize.width;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // final screenWidth = WidgetsBinding.instance.window.physicalSize.width;
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
                Provider.of<Auth>(ctx, listen: false).getUserId,
                Provider.of<Auth>(ctx, listen: false).getAuthToken,
                Provider.of<Auth>(ctx, listen: false).getAuthTokenExpiryDate,
              ),
              update: (ctx, auth, inventory) => Inventory(
                // inventory!.userId,
                // inventory.authToken,
                // inventory.authTokenExpiryDate,
                auth.getUserId,
                auth.getAuthToken,
                auth.getAuthTokenExpiryDate,
                // Provider.of<Auth>(ctx, listen: false).getUserId,
                // Provider.of<Auth>(ctx, listen: false).getAuthToken,
                // Provider.of<Auth>(ctx, listen: false).getAuthTokenExpiryDate,
              ),
            ),
            ChangeNotifierProvider(create: (ctx) => Cart()),
            ChangeNotifierProxyProvider<Auth, Orders>(
              create: (ctx) => Orders(
                Provider.of<Auth>(ctx, listen: false).getUserId,
                Provider.of<Auth>(ctx, listen: false).getAuthToken,
                Provider.of<Auth>(ctx, listen: false).getAuthTokenExpiryDate,
              ),
              update: (ctx, auth, _) => Orders(
                auth.getUserId,
                auth.getAuthToken,
                auth.getAuthTokenExpiryDate,
              ),
            ),
          ],
          child: Consumer<Auth>(
            builder: (ctx, auth, _) => MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'Bitches Be Shopping',
              theme: AppTheme.lightTheme(lightColorScheme),
              // .copyWith(
              //   textTheme: Theme.of(context).textTheme.apply(
              //         // fontSizeFactor: 1.0,
              //         fontSizeFactor: screenWidth / 1080,
              //       ),
              // ),
              darkTheme: AppTheme.darkTheme(darkColorScheme),
              home: FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (ctx, authSnapshot) {
									print('TRYING AUTO LOGIN: ${authSnapshot.connectionState}');
                  if (authSnapshot.connectionState == ConnectionState.waiting) {
                    return SplashScreen();
                  }
                  if (auth.isAuth) {
										print('AUTOLOGIN AUTHORIZED -> PRODUCTSSCREEN');
                    return ProductsScreen();
                  } else {
										print('AUTOLOGIN NOT AUTHORIZED -> AUTHSCREEN');
                    return AuthScreen();
                  }
                  // print('TRYING AUTO LOGIN: ${authSnapshot.connectionState}');
                  // // if (authSnapshot.connectionState != ConnectionState.waiting)
                  // if (authSnapshot.connectionState == ConnectionState.done) {
                  //   print('IS AUTHORIZED: ${auth.isAuth}');
                  //   if (auth.isAuth == true) {
                  //     return ProductsScreen();
                  //   } else {
                  //     return AuthScreen();
                  //   }
                  // }
                  // return SplashScreen();
                },
              ),
              // home: auth.isAuth
              //     ? ProductsScreen()
              //     : FutureBuilder(
              //         future: auth.tryAutoLogin(),
              //         builder: (ctx, authSnapshot) =>
              //             authSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
              //       ),
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
