import 'package:epsi_shop/bo/product.dart';
import 'package:flutter/material.dart';

class Cart with ChangeNotifier {
  final List<Product> _listProducts = []; // Private list

  // Public getter for the list of products
  List<Product> get listProducts => _listProducts;

  void addProduct(Product product) {
    _listProducts.add(product);
    notifyListeners();
  }

  void removeProduct(Product product) {
    _listProducts.remove(product);
    notifyListeners();
  }

  void clearCart() {
    _listProducts.clear();
    notifyListeners();
  }

  double getTotalHT() {
    return _listProducts.fold(0, (total, product) => total + product.price);
  }

  double getTotalTTC() {
    return getTotalHT() * 1.2;
  }
}
