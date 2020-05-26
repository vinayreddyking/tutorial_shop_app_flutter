import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/orders.dart' show Orders;
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';
  @override
//  void initState() {
//    setState(() {
//      _isLoading = true;
//    });
//    Provider.of<Orders>(context, listen: false).getAndFetchOrders().then((_) {
//      setState(() {
//        _isLoading = false;
//      });
//    });
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
//    var orderItems = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).getAndFetchOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.error != null) {
              return Center(
                child: Text('An Error Occurred'),
              );
            } else {
              return Consumer<Orders>(
                builder: (context, orderItems, child) => ListView.builder(
                  itemCount: orderItems.items.length,
                  itemBuilder: (c, i) => OrderItem(orderItems.items[i]),
                ),
              );
            }
          }
        },
      ),
    );
  }
}
