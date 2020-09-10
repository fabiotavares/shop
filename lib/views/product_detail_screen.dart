import 'package:flutter/material.dart';

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

    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: false,
      //   title: Text(product.title),
      // ),
      body: CustomScrollView(
        slivers: [
          // áreas que podem ter scroll
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
                title: Text(product.title),
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: product.id,
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const DecoratedBox(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                        begin: Alignment(0, 0.8),
                        end: Alignment(0, 0),
                        colors: [
                          Color.fromRGBO(0, 0, 0, 0.6),
                          Color.fromRGBO(0, 0, 0, 0),
                        ],
                      )),
                    ),
                  ],
                )),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(height: 10),
              Text(
                'R\$ ${product.price}',
                style: TextStyle(color: Colors.grey, fontSize: 20),
                textAlign: TextAlign.center,
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
              SizedBox(height: 1000),
            ]),
          ),
        ],
      ),
    );
  }
}
