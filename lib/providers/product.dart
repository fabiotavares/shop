import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/exceptions/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite = false;

  Product({
    this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void _toggleFavorite() {
    isFavorite = !isFavorite;
    notifyListeners();
  }

  Future<void> toggleFavorite() async {
    // extratégio otimista: muda localmente antes e mostra para o usuário
    _toggleFavorite();

    try {
      // tenta atualizar no servidor
      final url = 'https://flutter-cod3r-6b033.firebaseio.com/products/$id.json';
      final response = await http.patch(
        url,
        body: json.encode({
          'isFavorite': isFavorite,
        }),
      );

      // verifica se houve erro
      if (response.statusCode >= 400) {
        // lança excessão pra cair no catch abaixo
        throw Exception;
      }
    } catch (e) {
      // desfazer a alteração antecipada
      _toggleFavorite();
      // retransmite a excessão para exibir mensagem ao usuário
      throw HttpException('Ocorreu um erro desconhecido!');
    }
  }
}
