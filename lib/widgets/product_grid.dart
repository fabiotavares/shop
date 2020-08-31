import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // obtendo a lista de produtos do provider (aqui tenho o contexto)
    final productsProvider = Provider.of<Products>(context);
    final products = productsProvider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(),
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        // este componente já tem scroll
        crossAxisCount: 2, // dois elementos na linha
        childAspectRatio: 3 / 2, //proporção dos elementos
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
    );
  }
}
