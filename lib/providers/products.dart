import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  Product productById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  List<Product> get sortFav {
    return _items.where((e) => e.isFavorite).toList();
  }

  Future<void> addProducts(Product p) async {
    const String url =
        'https://tutorial-flutter-shop-app.firebaseio.com/products.json';
    try {
      final res = await http.post(url,
          body: json.encode({
            'title': p.title,
            'description': p.description,
            'price': p.price,
            'imageUrl': p.imageUrl,
            'isFavorite': p.isFavorite,
          }));
      final newProduct = Product(
        title: p.title,
        description: p.description,
        price: p.price,
        imageUrl: p.imageUrl,
        id: json.decode(res.body)['name'],
      );
      print('hello ' + newProduct.id);
      _items.add(newProduct);
      notifyListeners();
    } catch (err) {
      print(err);
      throw err;
    }
  }

  void updateProducts(String id, Product p) {
    final productIndex = _items.indexWhere((p) => p.id == id);
    if (productIndex >= 0) {
      _items[productIndex] = p;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void removeProductById(String id) {
    _items.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
