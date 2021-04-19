import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception..dart';
import './product.dart';

class ProductsProvider with ChangeNotifier {
  List<Product> _items = [];

  final String authToken;
  final String userId;

  ProductsProvider(this.authToken, this._items, this.userId);

  /* Due to dart being a reference type language, the getter is so constructed to avoid giving direct access to the items in memory */
  List<Product> get items {
    // if(_showFavoriteOnly){
    //   return _items.where((prodItem) => prodItem.isFavorite).toList();
    // }
    return [..._items];
  }

  List<Product> get favItems {
    return items.where((prod) => prod.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  // void showFavoritesOnly(){
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll(){
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }

  Future<void> getProducts() async {
    var url = Uri.parse(
        'https://food-delivery-4645c.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData.isEmpty) {
        return;
      }
      url = Uri.parse(
          'https://food-delivery-4645c.firebaseio.com/userFavorites/$userId.json?auth=$authToken');
      final favoriteResponse = await http.get(url);
      final favoriteData = json.decode(favoriteResponse.body);
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
          id: prodId,
          title: prodData['title'],
          category: prodData['category'],
          description: prodData['description'],
          price: prodData['price'],
          isFavorite: favoriteData == null ? false : prodData[prodId] ?? false,
          imageUrl: prodData['imageUrl'],
        ));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw (error);
      // Add more login here
    }
    await http.get(url);
  }

  Future<void> addProduct(Product value) async {
    final url = Uri.parse(
        'https://food-delivery-4645c.firebaseio.com/products.json?auth=$authToken');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'title': value.title,
          'category': value.category,
          'description': value.description,
          'imageUrl': value.imageUrl,
          'price': value.price,
        }),
      );
      final newProduct = Product(
        title: value.title,
        category: value.category,
        description: value.description,
        price: value.price,
        imageUrl: value.imageUrl,
        id: json.decode(response.body)['name'],
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          'https://food-delivery-4645c.firebaseio.com/products/$id.json?auth=$authToken');
      await http.patch(url,
          body: json.encode({
            'title': newProduct.title,
            'category': newProduct.category,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          }));
      _items[prodIndex] = newProduct;
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productid) async {
    final url = Uri.parse(
        'https://food-delivery-4645c.firebaseio.com/products/$productid.json?auth=$authToken');
    final existingProductIndex =
        _items.indexWhere((prod) => prod.id == productid);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    existingProduct = null;
  }
}
