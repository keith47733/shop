import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/auth.dart';
import 'providers/cart.dart';
import 'providers/orders.dart';
import 'providers/inventory.dart';
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
          // Create a Provider tree.
          providers: [
            ChangeNotifierProvider(create: (ctx) => Auth()),
            // You can use a ChangeNotifierProxyProvider that relies on a previously defined ChangeNotifierProvider. Add the CNP you're relying on and CNP for the class you want to listen to <Auth, Products> and the update: argument when using a ProxyProvider. The CNPP returns a context, an Auth object, and the previous state of the Products object.
            // ChangeNotifierProxyProvider<Auth, Products>(
            //   create: (ctx) => Products(null, []),
            //   update: (ctx, auth, previousProducts) =>
            //       Products(auth.token!, previousProducts == null ? [] : previousProducts.allProducts),
            // ),
            // This seems like the bext approach - use the Auth Provider getter methods for the authToken and userId arguments.
            ChangeNotifierProvider(
              create: (ctx) => Inventory(
                Provider.of<Auth>(ctx, listen: false).token ?? '',
                Provider.of<Auth>(ctx, listen: false).userId ?? '',
              ),
            ),
            ChangeNotifierProvider(
              create: (ctx) => Cart(
                Provider.of<Auth>(ctx, listen: false).token ?? '',
                Provider.of<Auth>(ctx, listen: false).userId ?? '',
              ),
            ),
            ChangeNotifierProvider(
              create: (ctx) => Orders(
                Provider.of<Auth>(ctx, listen: false).token ?? '',
                Provider.of<Auth>(ctx, listen: false).userId ?? '',
              ),
            ),
          ],
          // This will listen for any changes to the Auth object and return a sub context, instance of the Auth object, and a null child.
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
              // Want to check if the user is authenticated and then direct them to signup/login screen or products screen by wrapping the MaterialApp in a Consumer.of<Auth>. Thus, any changes to Auth will rebuild the MaterialApp assuming Auth notifyListeners().
              // The Auth.logout() sets the user info to null and notifyListeners(). The Consumer<Auth> above will hear the change and rebuild the MaterialApp, this time Auth.isAuth will be false and the user will be directed to the AuthScreen.
              // This home: argument is checked everytime the user navigates to a different screen. So as it is now, the user's token will expire but the user will only be logged out (taken to the AuthScreen) when the user changes screens. We want to logout the user immediatley. So we just need a way to trigger tryAutoLogin automatically.
              // If auth.isAuth = true, we know the user is logged in and can continue to ProductScreen(). If auth.isAuth = false, the app may have been closed and re-opened within the token expiry data so we can try to automatically login with a FutureBuilder (which returns the function value as .data in a Future object snapshot which also includes await properties like ConnectionState).
              home: auth.isAuth
                  ? ProductsScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (ctx, authSnapshot) =>
                          authSnapshot.connectionState == ConnectionState.waiting ? SplashScreen() : AuthScreen(),
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
