import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../models/product.dart';

class ProductsDetailScreen extends StatelessWidget {
  static const routeName = '/products_detail_screen';
  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context).settings.arguments as String;
    final Product item = Provider.of<Products>(
      context,
      listen: false,
    ).findById(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
      ),
      body: Center(
        child: Text('title body'),
      ),
    );
  }
}
