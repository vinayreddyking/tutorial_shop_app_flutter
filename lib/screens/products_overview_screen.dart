import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';
import 'package:shop_app/providers/products.dart';
import 'package:shop_app/screens/cart_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/badge.dart';
import 'package:shop_app/widgets/products_grid.dart';

enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  _ProductsOverviewScreenState createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  bool showOnlyFav = false;
  bool _isLoading = false;
  bool _isInitOnce = false;
  @override
  void initState() {
    /* setState(() {
      _isLoading = true;
    });

    Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts()
        .catchError((e) => print(e))
        .then((_) {
      setState(() {
        _isLoading = false;
      });
    });*/ // i don't know why but it is not working well.
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (!_isInitOnce) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context)
          .fetchAndSetProducts()
          .then((_) => setState(() {
                _isLoading = false;
              }));
      _isInitOnce = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
        actions: <Widget>[
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => <PopupMenuItem<FilterOptions>>[
              PopupMenuItem<FilterOptions>(
                child: Text('Show Favourites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem<FilterOptions>(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
            ],
            onSelected: (FilterOptions selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites)
                  showOnlyFav = true;
                else
                  showOnlyFav = false;
              });
            },
          ),
          Consumer<Cart>(
            builder: (_, cart, ch) => Badge(
              child: ch,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.pushNamed(context, CartScreen.routeName),
            ),
          ),
//          Icon(Icons.shopping_cart),
        ],
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductsGrid(showOnlyFav),
    );
  }
}
