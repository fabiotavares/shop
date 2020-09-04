import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/product.dart';
import 'package:shop/providers/products.dart';
import 'package:shop/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  final Product product;

  // vou passar o produto por parâmetro
  const ProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                // chamar a tela de formulário com o produto nos argumentos,
                // para sua edição...
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCTS_FORM,
                  arguments: product,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Theme.of(context).errorColor,
              onPressed: () {
                // confirma se deve excluir o cadastro do produto
                showDialog(
                  // retorna um Future
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: Text('Tem certeza?'),
                    content: Text('Quer remover o produto?'),
                    actions: [
                      FlatButton(
                        child: Text('Não'),
                        onPressed: () => Navigator.of(ctx).pop(false),
                      ),
                      FlatButton(
                        child: Text('Sim'),
                        onPressed: () => Navigator.of(ctx).pop(true),
                      ),
                    ],
                  ),
                ).then((confirmou) {
                  if (confirmou) {
                    // remover um produto do cadastro
                    // listen = false pois estou chamando fora do build dele
                    Provider.of<Products>(context, listen: false)
                        .removeItem(product.id);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
