import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';

class CartItemWidtget extends StatelessWidget {
  final CartItem cartItem;

  const CartItemWidtget(this.cartItem);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      // show de widget ... muito legal!!
      key: ValueKey(cartItem.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
      ),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) {
        // conforma a operação de delete
        return showDialog(
          // retorna um Future
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Tem certeza?'),
            content: Text('Quer remover o item do carrinho?'),
            actions: [
              FlatButton(
                child: Text('Não'),
                onPressed: () {
                  //é preciso fechar a view com pop passando false
                  Navigator.of(ctx).pop(false);
                },
              ),
              FlatButton(
                child: Text('Sim'),
                onPressed: () {
                  //é preciso fechar a view com pop passando true
                  Navigator.of(ctx).pop(true);
                },
              ),
            ],
          ),
        );
      },
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false)
            .removeItem(cartItem.productId);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 4,
        ),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: FittedBox(
                  child: Text('${cartItem.price}'),
                ),
              ),
            ),
            title: Text(cartItem.title),
            subtitle: Text(
                'Total: R\$ ${(cartItem.price * cartItem.quantity).toStringAsFixed(2)}'),
            trailing: Text('${cartItem.quantity}x'),
          ),
        ),
      ),
    );
  }
}
