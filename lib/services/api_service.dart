import 'dart:convert';

import 'package:epsi_shop/bo/product.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://fakestoreapi.com/products";

  // Récupérer la liste des produits
  static Future<List<Product>> getProducts() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      List<dynamic> listMapProducts = jsonDecode(response.body);
      return listMapProducts.map((map) => Product.fromMap(map)).toList();
    }
    throw Exception("Erreur de téléchargement des produits");
  }

  // Récupérer un produit par son ID
  static Future<Product> getSingleProduct(int id) async {
    final response = await http.get(Uri.parse("$baseUrl/$id"));
    if (response.statusCode == 200) {
      Map<String, dynamic> mapProduct = jsonDecode(response.body);
      return Product.fromMap(mapProduct);
    }
    throw Exception("Erreur de téléchargement du produit");
  }
}
