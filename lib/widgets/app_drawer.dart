import 'package:flutter/material.dart';
import 'package:shop/utils/app_routes.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('Bem vindo Usuário!'),
            // retira o ícone da appBar
            automaticallyImplyLeading: false,
          ),
          // UserAccountsDrawerHeader(
          //   accountName: Text('Fábio Tavares'),
          //   accountEmail: Text('fabreder@gmail.com'),
          //   currentAccountPicture: CircleAvatar(
          //     backgroundImage: NetworkImage(''),
          //   ),
          // ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Loja'),
            onTap: () =>
                // abre home substituindo esta tela, pra evitar o empilhamento
                Navigator.pushReplacementNamed(context, AppRoutes.AUTH_HOME),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Pedidos'),
            onTap: () =>
                // abre pedidos substituindo esta tela, pra evitar o empilhamento
                Navigator.pushReplacementNamed(context, AppRoutes.ORDERS),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Gerenciar Produtos'),
            onTap: () =>
                // abre produtos substituindo esta tela, pra evitar o empilhamento
                Navigator.pushReplacementNamed(context, AppRoutes.PRODUCTS),
          ),
        ],
      ),
    );
  }
}
