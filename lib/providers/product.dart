import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    this.imageUrl,
    this.isFavorite = false,
  });

  factory Product.from (Product p, {String id}) {
    return Product(id: id, title: p.title, description: p.description, price: p.price, imageUrl: p.imageUrl);
  }

  toggleFavoriteStatus() async {
    final url = 'https://fluttershop-4c03c.firebaseio.com/products/$id.json';
    isFavorite = !isFavorite;
    notifyListeners();
    final response = await http.patch(url, body: json.encode({
        'isFavorite': isFavorite
      }));
    if (response.statusCode >= 400) {
      // roll back changes
      isFavorite = !isFavorite;
      notifyListeners();
      throw HttpException('Could not update favorite status');
    }
  }
}
