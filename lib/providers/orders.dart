import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shop/providers/cart.dart';

class Order {
  final String id;
  final double total;
  final List<CartItem> products;
  final DateTime date;

  Order({
    @required this.id,
    @required this.total,
    @required this.products,
    @required this.date,
  });
}

class Orders with ChangeNotifier {
  final _baseUrl = 'https://flutter-cod3r-6b033.firebaseio.com/orders';
  List<Order> _items = [];

  Future<void> loadOrders() async {
    List<Order> loadItems = [];

    // decodificando a resposta para obter a lista de produtos
    final response = await http.get('$_baseUrl.json');
    Map<String, dynamic> data = json.decode(response.body);

    if (data != null) {
      // pegar dados atualizados
      data.forEach((orderId, orderData) {
        loadItems.add(
          Order(
            id: orderId,
            total: orderData['total'],
            date: DateTime.parse(orderData['date']),
            products: (orderData['products'] as List<dynamic>).map((item) {
              return CartItem(
                id: item["id"],
                price: item["price"],
                productId: item["productId"],
                quantity: item["quantity"],
                title: item["title"],
              );
            }).toList(),
          ),
        );
      });
      // atualizar exibição dos dados
      notifyListeners();
    }

    // obtém a lista invertida (mais recente vem antes)
    _items = loadItems.reversed.toList();
    return Future.value();
  }

  List<Order> get items {
    // retorne uma cópia da lista de itemCart
    return [..._items];
  }

  int get itemsCount {
    return _items.length;
  }

  Future<void> addOrder(Cart cart) async {
    final date = DateTime.now();
    final response = await http.post(
      '$_baseUrl.json',
      body: json.encode({
        "total": cart.totalAmount,
        "date": date.toIso8601String(),
        "products": cart.items.values
            .map((cartItem) => {
                  "id": cartItem.id,
                  "productId": cartItem.productId,
                  "title": cartItem.title,
                  "quantity": cartItem.quantity,
                  "price": cartItem.price,
                })
            .toList(),
      }),
    );

    // insere pedido na posição zero, deslocando todos para frente
    _items.insert(
        0,
        Order(
          id: json.decode(response.body)['name'],
          total: cart.totalAmount,
          date: date,
          products: cart.items.values.toList(),
        ));

    // notificar alterações
    notifyListeners();
  }
}
