import 'package:flutter/material.dart';
import 'package:shop/widgets/product_grid.dart';

// tela com um GridView para exibir os produtos

class ProductOverviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Minha Loja'),
      ),
      body: ProductGrid(),
    );
  }
}
