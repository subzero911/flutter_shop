import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shop_app/setup/widget_view.dart';

import '../providers/orders.dart' as model;

class OrderItem extends StatefulWidget {
  final model.OrderItem order;

  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;

  void onTilePressed() {
    setState(() {
      _expanded = !_expanded;
    });
  }

  @override
  Widget build(BuildContext context) => OrderItemView(this);
}

// ----------------------------------  UI  -------------------------------------------------------

class OrderItemView extends WidgetView<OrderItem, _OrderItemState> {
  final state;  
  const OrderItemView(this.state) : super(state);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          ListTile(            
            title: Text('\$${widget.order.amount.toStringAsFixed(2)}'),
            subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(state._expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: state.onTilePressed,
            ),
          ),
          if (state._expanded)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
              height: min(widget.order.products.length * 20.0 + 10, 100),
              child: ListView(
                children: widget.order.products
                    .map(
                      (prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(prod.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('${prod.quantity} x \$${prod.price}', style: TextStyle(fontSize: 18, color: Colors.grey)),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
