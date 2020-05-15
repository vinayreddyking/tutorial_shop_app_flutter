import 'package:flutter/foundation.dart';

import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _items = [];

  List<OrderItem> get items {
    return [..._items];
  }

  void addOrders(List<CartItem> cartItems, double total) {
    _items.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: total,
        products: cartItems,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
