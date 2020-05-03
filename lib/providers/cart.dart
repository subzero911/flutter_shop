import 'package:flutter/foundation.dart';

class CartItem {
  // id of CartItem не равен id of Product! Это отдельная сущность.
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem({@required this.id, @required this.title, @required this.quantity, @required this.price});
}

class Cart with ChangeNotifier {
  // ключ = id продукта
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.values.fold(0, (prev, e) => prev + e.quantity);
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      // change quantity
      _items.update(
          productId,
          (existingItem) => CartItem(
                id: existingItem.id,
                title: existingItem.title,
                price: existingItem.price,
                quantity: existingItem.quantity + 1,
              ));
    } else {
      // add new CartItem
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                price: price,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  // remove all bunch of products on dismiss
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // on press UNDO
  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      // if we have more than 1 products of type
      _items.update(
          productId,
          (existingCartItem) => CartItem(
                id: existingCartItem.id,
                title: existingCartItem.title,
                price: existingCartItem.price,
                quantity: existingCartItem.quantity - 1,
              ));
    } else {
      // if we have only 1 product
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
