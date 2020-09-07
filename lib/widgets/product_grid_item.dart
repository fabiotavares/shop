import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/exceptions/http_exception.dart';
import 'package:shop/providers/auth.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/utils/app_routes.dart';

class ProductGridItem extends StatelessWidget {
  final void Function() updateGridIsShowFavoriteOnly;

  const ProductGridItem(this.updateGridIsShowFavoriteOnly);

  @override
  Widget build(BuildContext context) {
    // necessário pra funcionar com o último elemento da lista (não entendi)
    final scaffold = Scaffold.of(context);
    // obtendo o produto através do provider e não mais como parâmetro
    final Product product = Provider.of<Product>(context, listen: false);
    final Cart cart = Provider.of<Cart>(context, listen: false);
    final Auth auth = Provider.of<Auth>(context, listen: false);

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
              onPressed: () async {
                try {
                  await product.toggleFavorite(auth.token);
                  // atualiza grid de produtos se necessário
                  updateGridIsShowFavoriteOnly();
                } on HttpException catch (e) {
                  //exibir mensagem de erro com snackbar
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
            ),
          ),
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              // isso vai retornar o scaffold existente na hierarquia de context
              // e vai encontrar o objeto em ProductOverviewScreen
              //Scaffold.of(context).openDrawer();
              scaffold.hideCurrentSnackBar(); // fecha a anterior logo
              scaffold.showSnackBar(
                SnackBar(
                  content: Text('Produto adicionado com sucesso!'),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(
                    label: 'DESFAZER',
                    onPressed: () {
                      // remove uma unidade do item (ou o item se tiver apenas 1)
                      cart.removeSingleItem(product.id);
                    },
                  ),
                ),
              );
              cart.addItem(product);
            },
          ),
        ),
      ),
    );
  }
}
