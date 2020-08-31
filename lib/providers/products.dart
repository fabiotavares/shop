import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/models/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;

  // esse get retorna uma cópia da lista (através do operador
  // spread), para evitar acesso direto ao seu conteúdo
  List<Product> get items => [..._items];

  void addProduct(Product product) {
    _items.add(product);

    // houve uma alteração na lista que precisa ser notificada
    // usando um método da classe mixins ChangeNotifier
    notifyListeners();
  }
}
