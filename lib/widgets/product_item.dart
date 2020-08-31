import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop/models/product.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // obtendo o produto através do provider e não mais como parâmetro
    final Product product = Provider.of<Product>(context, listen: false);
    // * o padrão é true, ou seja, quero escutar as modificações no objeto;
    // mas posso querer parar de escutar (quando envolver apenas finais)
    // então, basta marcar como false esse parâmetro

    return ClipRRect(
      // para ter as bordas arredondadas
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              AppRoutes.PRODUCT_DETAIL,
              arguments: product,
            );
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black87,
          leading: Consumer<Product>(
            child: Text('Nunca muda'),
            // ouvindo só aqui (cirúrgico!)
            builder: (ctx, product, child) => IconButton(
              // posso usar aqui o child para referenciar uma parte que não
              // deve mudar dentro desse Consumer
              icon: Icon(
                  product.isFavorite ? Icons.favorite : Icons.favorite_border),
              color: Theme.of(context).accentColor,
              onPressed: () => product.toggleFavorite(),
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {},
          ),
        ),
      ),
    );
  }
}
