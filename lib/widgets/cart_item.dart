import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String productId;
  final double price;
  final int quantity;
  final String title;
  CartItem(this.id, this.productId, this.price, this.quantity, this.title);
  @override
  Widget build(BuildContext context) {
    var cart = Provider.of<Cart>(context);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      child: Dismissible(
        key: ValueKey(id),
        background: Container(
          color: Theme.of(context).errorColor,
          child: Icon(
            Icons.delete,
            color: Colors.white,
            size: 40,
          ),
          margin: EdgeInsets.symmetric(vertical: 1, horizontal: 0),
          alignment: Alignment.centerRight,
          padding: EdgeInsets.only(right: 8),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          cart.removeItemById(productId);
        },
        confirmDismiss: (_) {
          return showDialog<bool>(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text('Are You Sure?'),
              content: Text('Do You want to Remove Item from the Cart!'),
              backgroundColor: Colors.white,
              actions: <Widget>[
                OutlineButton(
                  child: Text('No'),
                  onPressed: () => Navigator.pop(ctx, false),
                ),
                OutlineButton(
                  child: Text('Yes'),
                  onPressed: () => Navigator.pop(ctx, true),
                ),
              ],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
            ),
          );
        },
        child: Card(
          margin: EdgeInsets.symmetric(
            horizontal: 0,
            vertical: 0,
          ),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: FittedBox(
                    child: Text('\$$price'),
                  ),
                ),
              ),
              title: Text(title),
              subtitle:
                  Text('Total : \$${(price * quantity).toStringAsFixed(2)}'),
              trailing: Text('$quantity x'),
            ),
          ),
        ),
      ),
    );
  }
}
