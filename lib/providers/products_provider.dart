import 'package:flutter/material.dart';
import 'package:provider_app/models/http_exception.dart';
import 'package:provider/provider.dart';
import 'product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imgUrl:
      'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imgUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imgUrl: 'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imgUrl:
      'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouritItems {
    return _items.where((item) => item.isFavourite).toList();
  }

  Future<void> addProduct(Product product) async {
    final url =
    Uri.parse("https://online-shop-5e10b-default-rtdb.firebaseio.com");
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'imgUrl': product.imgUrl,
            'price': product.price,
            'isFavourite': product.isFavourite,
          }));
      _items.add(Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imgUrl: product.imgUrl,
      ));
      notifyListeners();
    } catch (error) {
      print(error);
      throw (error);
    }
  }

  Future<void> fetchProducts() async {
    const url = "https://online-shop-5e10b-default-rtdb.firebaseio.com";
    try {
      final response = await http.get(Uri.parse(url));
      final fetchedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> fetchedList = [];
      fetchedData.forEach((id, data) {
        fetchedList.add(Product(
          id: id,
          title: data['title'],
          price: data['price'],
          description: data['description'],
          imgUrl: data['imgUrl'],
          isFavourite: data['isFavourite'],
        ));
      });
      _items = fetchedList;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> removeItem(String productId) async {
    const url = "https://online-shop-5e10b-default-rtdb.firebaseio.com";
    final productIndex =
    _items.indexWhere((product) => product.id == productId);
    var productReference = _items[productIndex];
    _items.removeAt(productIndex);
    notifyListeners();
    final response = await http.delete(Uri.parse(url));
    if (response.statusCode >= 400) {
      _items.insert(productIndex, productReference);
      notifyListeners();
      throw HttpException("Couldn't delete!");
    }
    productReference.dispose();
  }

  Product findProductById(String productId) {
    return _items.firstWhere((product) => product.id == productId);
  }
}