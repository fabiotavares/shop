import 'package:flutter/material.dart';

import 'package:shop/models/product.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // como estou navegando por rotas nomeadas no main,
    // onde não estou usando um construtor com parämetros,
    // preciso então instanciar o produto aqui através do que
    // foi passado na chamada da rota...
    final Product product =
        ModalRoute.of(context).settings.arguments as Product;

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(product.title),
          onTap: () => product.toggleFavorite(),
        ),
      ),
      body: Container(),
    );
  }
}
