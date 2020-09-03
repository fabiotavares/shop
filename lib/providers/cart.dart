import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:shop/providers/product.dart';

class CartItem {
  final String id;
  final String productId;
  final String title;
  final int quantity;
  final double price;

  CartItem({
    @required this.id,
    @required this.productId,
    @required this.title,
    @required this.quantity,
    @required this.price,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemsCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });

    return total;
  }

  void addItem(Product product) {
    // se o produto já estiver no carrinho...
    if (_items.containsKey(product.id)) {
      // retorne um novo item de carrinho com a quantidade atualizada...
      _items.update(product.id, (existingItem) {
        return CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          title: existingItem.title,
          quantity: existingItem.quantity + 1,
          price: existingItem.price,
        );
      });
    } else {
      // incluir se não estiver presente
      _items.putIfAbsent(product.id, () {
        return CartItem(
          id: Random().nextDouble().toString(),
          productId: product.id,
          title: product.title,
          quantity: 1,
          price: product.price,
        );
      });
    }

    // notifica modificação
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    // remove uma unidade do item no carrinho
    // se houver apenas uma, remove o item do carrinho
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId].quantity == 1) {
      // se tiver apenas 1, remove do carrinho
      _items.remove(productId);
    } else {
      // atualiza a quantidade através de um novo objeto
      _items.update(productId, (existingItem) {
        return CartItem(
          id: existingItem.id,
          productId: existingItem.productId,
          title: existingItem.title,
          quantity: existingItem.quantity - 1,
          price: existingItem.price,
        );
      });
    }
    // notifica os providers da alteração
    notifyListeners();
  }

  void removeItem(String productId) {
    // remove um item do carrinho
    _items.remove(productId);
    // notifica modificação
    notifyListeners();
  }

  // limpa o carrinho
  void clear() {
    _items = {};
    notifyListeners();
  }
}
