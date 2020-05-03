import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import './cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({@required this.id, @required this.amount, @required this.products, @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return List.of(_orders);
  }

  Future<void> fetchOrders() async {
    const url = 'https://fluttershop-4c03c.firebaseio.com/orders.json';
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) return;
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
        id: orderId,
        amount: orderData['amount'],
        dateTime: DateTime.parse(
          orderData['dateTime'],
        ),
        products: (orderData['products'] as List<dynamic>)
            .map((item) => CartItem(
                  id: item['id'],
                  price: item['price'],
                  title: item['title'],
                  quantity: item['quantity'],
                ))
            .toList(),
      ));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://fluttershop-4c03c.firebaseio.com/orders.json';
    final timestamp = DateTime.now();
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': total,
            'dateTime': timestamp.toIso8601String(),
            'products': cartProducts
                .map((cp) => {
                      'id': cp.id,
                      'title': cp.title,
                      'price': cp.price,
                      'quantity': cp.quantity,
                    })
                .toList(),
          }));
      _orders.insert(
          0, // добавляем новые заказы в начало списка
          OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timestamp,
          ));
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
