import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavoritesOnly;
  const ProductGrid(this.showFavoritesOnly);

  @override
  Widget build(BuildContext context) {
    // obtendo a lista de produtos do provider (aqui tenho o contexto)
    final productsProvider = Provider.of<Products>(context);
    final products = showFavoritesOnly
        ? productsProvider.favoriteItems
        : productsProvider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      // forma de cadastrar um provider a partir de um elemento já existente
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
