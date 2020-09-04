import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/data/dummy_data.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = DUMMY_PRODUCTS;
  // bool _showFavoriteOnly = false;

  // esse get retorna uma cópia da lista (através do operador
  // spread), para evitar acesso direto ao seu conteúdo
  List<Product> get items => [..._items];

  int get itemsCount {
    return _items.length;
  }

  // lista de favoritos somente
  List<Product> get favoriteItems {
    return _items.where((prod) => prod.isFavorite).toList();
  }

  void addProduct(Product newProduct) {
    // adiciona um novo produto igual ao passado e com a geração do id aqui
    _items.add(Product(
      id: Random().nextDouble().toString(),
      title: newProduct.title,
      description: newProduct.description,
      price: newProduct.price,
      imageUrl: newProduct.imageUrl,
    ));
    // houve uma alteração na lista que precisa ser notificada
    // usando um método da classe mixins ChangeNotifier
    notifyListeners();
  }

  // método compartilhando globalmente a informação de favoritos

  // List<Product> get items {
  //   if (_showFavoriteOnly) {
  //     // retorna a lista (já duplicada) só com produtos favoritos
  //     return _items.where((prod) => prod.isFavorite).toList();
  //   }
  //   return [..._items];
  // }

  // // métodos para alterar o status de favorito do produto
  // void showFavoriteOnly() {
  //   _showFavoriteOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoriteOnly = false;
  //   notifyListeners();
  // }
}
