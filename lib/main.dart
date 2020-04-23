import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/products_detail_screen.dart';
import './providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) => Products(),
      child: MaterialApp(
        title: 'My Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
          fontFamily: 'Lato',
        ),
        debugShowCheckedModeBanner: false,
        // home: MyHomePage(),
        initialRoute: '/',
        routes: {
          '/': (ctx) => ProductsOverviewScreen(),
          ProductsDetailScreen.routeName: (ctx) => ProductsDetailScreen(),
        },
      ),
    );
  }
}
