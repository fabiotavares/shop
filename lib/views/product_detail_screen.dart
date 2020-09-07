import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/auth.dart';

import 'package:shop/providers/product.dart';

class ProductDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // como estou navegando por rotas nomeadas no main,
    // onde não estou usando um construtor com parämetros,
    // preciso então instanciar o produto aqui através do que
    // foi passado na chamada da rota...
    final Product product =
        ModalRoute.of(context).settings.arguments as Product;
    final Auth auth = Provider.of<Auth>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          child: Text(product.title),
          onTap: () => product.toggleFavorite(auth.token),
        ),
      ),
      body: SingleChildScrollView(
        // uso quando a tela vai ocupar mais do que é visível
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'R\$ ${product.price}',
              style: TextStyle(color: Colors.grey, fontSize: 20),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              width: double.infinity,
              child: Text(
                product.description,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
