import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:provider_app/providers/cart_provider.dart';
import 'package:provider_app/providers/orders_provider.dart';
import 'package:provider_app/providers/products_provider.dart';
import 'package:provider_app/screens/cart_screen.dart';
import 'package:provider_app/screens/edit_product_screen.dart';
import 'package:provider_app/screens/orders_screen.dart';
import 'package:provider_app/screens/product_details_screen.dart';
import 'package:provider_app/screens/user_products_screen.dart';
import 'package:provider_app/screens/products_overview_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ProductsProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => CartProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => OrdersProvider(),
        )
      ],
      child: MaterialApp(
        title: 'My Online Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          colorScheme: ThemeData().colorScheme.copyWith(
            secondary: Colors.deepOrange, // Accent color replacement
          ),
          fontFamily: 'Quicksand',
        ),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailsScreen.routeName: (context) => ProductDetailsScreen(),
          CartScreen.routeName: (context) => CartScreen(),
          OrdersScreen.routeName: (context) => OrdersScreen(),
          UserProductsScreen.routeName: (context) => UserProductsScreen(),
          EditProductScreen.routeName: (context) => EditProductScreen(),
        },
      ),
    );
  }
}
