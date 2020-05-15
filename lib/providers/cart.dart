import 'package:flutter/foundation.dart';

class CartItem {
  final String id;

  final String title;

  final int quantity;

  final double price;
  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double amount = 0.00;
    _items.forEach((k, v) {
      amount += v.price * v.quantity;
    });
    return amount;
  }

  void removeItemById(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void addItems(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (prod) => CartItem(
                quantity: prod.quantity + 1,
                title: prod.title,
                price: prod.price,
                id: prod.id,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                price: price,
                title: title,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
