import 'package:flutter/material.dart';
import 'package:food_delivery/providers/product.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products_provider.dart';
import './providers/cart.dart';
import './providers/orders_provider.dart';
import './providers/auth.dart';
import './helpers/custom_route.dart';
import './screens/cart_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart.dart';
import './screens/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          create: (_) => ProductsProvider('', <Product>[], ''),
          update: (ctx, auth, previousProducts) => ProductsProvider(
              auth.token == null ? '' : auth.token!,
              previousProducts == null ? [] : previousProducts.items,
              auth.userId == null ? '' : auth.token!),
        )
        /*ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          // create: (ctx) => ProductsProvider(),
          // above is an alternative to the implementation below available in version 3 of the provider package, when the '.value' portion is removed
          update: (ctx, auth, previousProducts) => ProductsProvider(
              auth.token,
              previousProducts == null ? [] : previousProducts.items,
              auth.userId),
        ))*/
        ,
        ChangeNotifierProvider.value(
          value: CartProvider(),
        ),
        ChangeNotifierProxyProvider<Auth, OrdersProvider>(
          create: (_) => OrdersProvider('', <OrderItem>[], ''),
          update: (ctx, auth, previousOrders) => OrdersProvider(
            auth.token!,
            previousOrders == null ? [] : previousOrders.orders,
            auth.userId!,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (context, auth, _) => MaterialApp(
          title: 'ShopLine',
          theme: ThemeData(
            primarySwatch: Colors.indigo,
            accentColor: Colors.redAccent,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: CustomPageTransitionBuilder(),
                TargetPlatform.iOS: CustomPageTransitionBuilder(),
              },
            ),
          ),
          home: auth.isAuth
              ? ProductsOverviewScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapshot) => authResultSnapshot
                              .connectionState ==
                          ConnectionState.waiting
                      ? SplashScreen()
                      : AuthScreen(), // If token is present then user is loged in,  otherwise they are taken to the signup screen
                ),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
            EditProductScreen.routeName: (ctx) => EditProductScreen(),
          },
        ),
      ),
    );
  }
}
