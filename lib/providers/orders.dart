import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

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

  Future<void> getAndFetchOrders() async {
    final url = 'https://tutorial-flutter-shop-app.firebaseio.com/orders.json';
    List<OrderItem> orderedItems = [];
    final res = await http.get(url);
    final extractedData = json.decode(res.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach((orderId, orderData) {
      orderedItems.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          products: (orderData['products'] as List<dynamic>)
              .map((cItem) => CartItem(
                    id: cItem['id'],
                    title: cItem['title'],
                    quantity: cItem['quantity'],
                    price: cItem['price'],
                  ))
              .toList(),
          dateTime: DateTime.parse(orderData['dateTime'])));
    });
    //_items = List<OrderItem>.from(orderedItems.reversed);
    _items = orderedItems.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrders(List<CartItem> cartItems, double total) async {
    final DateTime timeStamp = DateTime.now();
    final url = 'https://tutorial-flutter-shop-app.firebaseio.com/orders.json';
    final res = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': timeStamp.toIso8601String(),
          'products': cartItems
              .map((e) => {
                    'id': e.id,
                    'price': e.price,
                    'title': e.title,
                    'quantity': e.quantity,
                  })
              .toList(),
        }));
    _items.insert(
      0,
      OrderItem(
        id: json.decode(res.body)['name'],
        amount: total,
        products: cartItems,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
