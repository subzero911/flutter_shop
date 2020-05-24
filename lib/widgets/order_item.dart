import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './viewmodels/order_item_vm.dart';

import '../providers/orders.dart' as model;

class OrderItem extends StatelessWidget {
  final OrderItemVm _viewModel = OrderItemVm(); 

  final model.OrderItem order;  
  OrderItem(this.order);


  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: StreamBuilder<bool>(
        initialData: false,
        stream: _viewModel.expanded,
        builder: (context, snapshot) {
          bool expanded = snapshot.data;
          return Column(
            children: <Widget>[
              ListTile(            
                title: Text('\$${order.amount.toStringAsFixed(2)}'),
                subtitle: Text(DateFormat('dd/MM/yyyy hh:mm').format(order.dateTime)),
                trailing: IconButton(
                  icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
                  onPressed: _viewModel.onTilePressed,
                ),
              ),
              if (expanded)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  height: min(order.products.length * 20.0 + 10, 100),
                  child: ListView(
                    children: order.products
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
          );
        }
      ),
    );
  }
}
