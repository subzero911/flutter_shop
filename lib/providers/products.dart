import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'product.dart';

class Products with ChangeNotifier {
  // приватный член, так как напрямую к нему никто не может обратиться
  // не финальный, так как будет меняться
  List<Product> _items = [];

  // публичная обертка
  List<Product> get items {
    // возвращаем копию списка (чтобы нельзя было поменять оригинал)
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Future<void> fetchProducts() async {
    const url = 'https://fluttershop-4c03c.firebaseio.com/products.json';
    try {
      final response = await http.get(url);
      final data = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      data.forEach((prodId, prodData) {
        loadedProducts.add(new Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          price: prodData['price'],
          imageUrl: prodData['imageUrl'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
     throw (error);
    }
  }

  Future<void> addProduct(Product product) {
    const url = 'https://fluttershop-4c03c.firebaseio.com/products.json';
    return http.post(url, body: json.encode(
        // new Map from product
        {
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
        }),
    ).then((response) {
      final newProduct = Product.from(product, id: json.decode(response.body)['name']);
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      print(error);
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = 'https://fluttershop-4c03c.firebaseio.com/products/$id.json';
      try {
        await http.patch(url, body: json.encode({
          'title': newProduct.title,
          'description': newProduct.description,
          'imageUrl': newProduct.imageUrl,
          'price': newProduct.price,
        }));
      } catch (error) {
        throw error;
      } finally {
        _items[prodIndex] = newProduct;
        notifyListeners();
      }
    }
  }

  // паттерн Optimistic Updating
  Future<void> deleteProduct(String id) async {
    final url = 'https://fluttershop-4c03c.firebaseio.com/products/$id.json';
    final existingProductIndex = _items.indexWhere((prod) => prod.id == id);
    // сохраняем указатель на элемент списка
    var existingProduct = _items[existingProductIndex];
    // удаляем из списка (элемент продолжит существовать в памяти)
    _items.removeAt(existingProductIndex);
    // перерисовываем
    notifyListeners();
    // уадляем с сервера
    final response = await http.delete(url);
    // если удаление сорвалось -- откатываем локальные изменения
    if (response.statusCode >= 400)
    {
      // возвращаем элемент в список
      _items.insert(existingProductIndex, existingProduct);
      // перерисовываем
      notifyListeners();
      // выходим
      throw HttpException('Could not delete product');
    }
    // если получилось - удаляем объект из памяти
    existingProduct = null;
  }

  Product findById(String id) {
    return _items.firstWhere((product) => product.id == id);
  }
}
