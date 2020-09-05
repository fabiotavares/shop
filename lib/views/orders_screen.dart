import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_widget.dart';

class OrdersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Meus Pedidos'),
      ),
      drawer: AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refreshOrders(context),
        child: FutureBuilder(
          //solução elegante para se obter dados futuros
          future: Provider.of<Orders>(context, listen: false).loadOrders(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // ainda não terminou
              return Center(child: CircularProgressIndicator());
              //
            } else if (snapshot.error != null) {
              // um erro inesperado
              return Center(child: Text('Ocorreu um erro!'));
              //
            } else {
              // finalizou o processamento
              // necessário usar o Consumer para obter o valor esperado
              return Consumer<Orders>(
                builder: (context, orders, child) {
                  return ListView.builder(
                    itemCount: orders.itemsCount,
                    itemBuilder: (ctx, i) => OrderWidtget(orders.items[i]),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }

  Future<void> _refreshOrders(BuildContext context) {
    // importante colocar listen: false
    return Provider.of<Orders>(context, listen: false).loadOrders();
  }
}
